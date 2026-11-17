pkgs:

combinators:
with combinators;
let
  lib = pkgs.lib;

  appDir = "~/.app/";
  appDirSubPath = state: subPath: "${appDir}/${escape state.appId}/${escape subPath}";

  runDir = "\"\${XDG_RUNTIME_DIR:-/run/user/$UID}/.jail-nix\"";
  runDirSubPath = state: subPath: "${runDir}/${escape state.appId}/${escape subPath}";

  xdgBaseDirs = lib.mapAttrs (_: v: v // { path = "\"\${${v.var}:-~/${v.dir}}\""; }) {
    config = {
      var = "XDG_CONFIG_HOME";
      dir = ".config";
    };
    data = {
      var = "XDG_DATA_HOME";
      dir = ".local/share";
    };
    state = {
      var = "XDG_STATE_HOME";
      dir = ".local/state";
    };
    cache = {
      var = "XDG_CACHE_HOME";
      dir = ".cache";
    };
  };
in
rec {
  # Minimal sandbox base for a Flatpak-style app id: tmpfs home, /proc,
  # /dev, store, fake passwd, portal access and a sanitized environment.
  base-xdg =
    appId:
    compose (
      [
        reset
        (set-app-id appId)
        (unsafe-add-raw-args "--proc /proc")
        (unsafe-add-raw-args "--dev /dev")
        (unsafe-add-raw-args "--tmpfs ~")
        (ro-bind "${pkgs.bash}/bin/sh" "/bin/sh")
        (add-path "/bin")
        (state: state // { additionalRuntimeClosures = state.additionalRuntimeClosures ++ [ pkgs.bash ]; })
        (add-pkg-deps [ pkgs.coreutils ])
        (add-pkg-deps (with pkgs; [ xdg-utils ]))
        (readonly "/nix/store")
        fake-passwd
        (try-ro-bind "/etc/os-release" "/run/host/os-release")
        desktop-portal
      ]
      # Environment variables automaticall unset by flatpak
      ++ (lib.map (var: unsafe-add-raw-args "--unsetenv ${var}") (
        [
          "PATH"
          "LD_LIBRARY_PATH"
          "LD_PRELOAD"
          "LD_AUDIT"
          "XDG_CONFIG_DIRS"
          "XDG_DATA_DIRS"
          "SHELL"
          "TEMP"
          "TEMPDIR"
          "TMP"
          "TMPDIR"
          "XDG_RUNTIME_DIR"
          "container"
          "TZDIR"
          "PYTHONPATH"
          "PYTHONPYCACHEPREFIX"
          "PERLLIB"
          "PERL5LIB"
          "XCURSOR_PATH"
          "GST_PLUGIN_PATH_1_0"
          "GST_REGISTRY"
          "GST_REGISTRY_1_0"
          "GST_PLUGIN_PATH"
          "GST_PLUGIN_SYSTEM_PATH"
          "GST_PLUGIN_SCANNER"
          "GST_PLUGIN_SCANNER_1_0"
          "GST_PLUGIN_SYSTEM_PATH_1_0"
          "GST_PRESET_PATH"
          "GST_PTP_HELPER"
          "GST_PTP_HELPER_1_0"
          "GST_INSTALL_PLUGINS_HELPER"
          "KRB5CCNAME"
          "XKB_CONFIG_ROOT"
          "GIO_EXTRA_MODULES"
          "GDK_BACKEND"
          "VK_ADD_DRIVER_FILES"
          "VK_ADD_LAYER_PATH"
          "VK_DRIVER_FILES"
          "VK_ICD_FILENAMES"
          "VK_LAYER_PATH"
          "__EGL_EXTERNAL_PLATFORM_CONFIG_DIRS"
          "__EGL_EXTERNAL_PLATFORM_CONFIG_FILENAMES"
          "__EGL_VENDOR_LIBRARY_DIRS"
          "__EGL_VENDOR_LIBRARY_FILENAMES"
        ]
        ++ (lib.map (v: v.var) (lib.attrValues xdgBaseDirs))
      ))
    );

  # Clears the environment before starting the jail.
  clearenv = unsafe-add-raw-args "--clearenv";

  # Grants DBus access to the desktop portal and the app's own bus name.
  desktop-portal =
    state:
    dbus {
      talk = [
        "org.freedesktop.portal.*"
      ];
      own = [
        state.appId
      ];
    } state;

  # Forwards `$PATH` with symlinks resolved, binding each entry read-only.
  fwd-path = compose [
    (add-path "\"$(printf '%s\\n' \"$PATH\" | tr ':' '\\n' | while IFS= read -r dir; do realpath -m \"$dir\"; done | paste -sd: -)\"")
    (readonly-paths-from-var "PATH" ":")
  ];

  # Same as the builtin gui combinator, but replaces
  # readonly-paths-from-var with resolved-paths-from-var. Profile
  # symlinks such as /etc/profiles/per-user/$USER/share are resolved
  # before entering the jail, so themes/icons/cursors can be found and
  # paths are not bind-mounted twice.
  gui-enhanced = compose [
    pulse
    pipewire
    wayland
    (runtime-deep-ro-bind (noescape "/etc/fonts"))
    (try-readonly (noescape "${xdgBaseDirs.config.path}/dconf"))
    (resolved-paths-from-var "XDG_DATA_DIRS" ":")
    # Without the dconf GSettings module, GSettings falls back to the
    # memory backend and ignores ~/.config/dconf.
    (resolved-paths-from-var "GIO_EXTRA_MODULES" ":")

    # Cursor
    (try-fwd-env "XCURSOR_THEME")
    (try-fwd-env "XCURSOR_SIZE")
    (resolved-paths-from-var "XCURSOR_PATH" " ")

    # Theme
    (try-fwd-env "GTK_THEME")
    (resolved-paths-from-var "GTK_PATH" ":")
    (try-readonly (noescape "${xdgBaseDirs.config.path}/gtk-2.0"))
    (try-readonly (noescape "${xdgBaseDirs.config.path}/gtk-3.0"))
    (try-readonly (noescape "${xdgBaseDirs.config.path}/gtk-4.0"))
    (try-readonly (noescape "~/.icons"))
    (try-fwd-env "QT_QPA_PLATFORMTHEME")

    (try-fwd-env "GTK_A11Y")
  ];

  # Mounts a `0000`-permission tmpfs so the path cannot be accessed.
  inaccessible-path =
    path:
    compose [
      (unsafe-add-raw-args "--perms 0000")
      (tmpfs path)
    ];

  # Lets the app inhibit idle/screensaver over DBus.
  inhibit-idle = dbus {
    talk = [
      "org.freedesktop.ScreenSaver"
    ];
  };

  # Forwards locale-related environment variables.
  locale = compose (
    lib.map try-fwd-env [
      "LOCALE_ARCHIVE"
      "LOCALE_ARCHIVE_2_11"
      "LOCALE_ARCHIVE_2_27"
      "LC_CTYPE"
      "LC_NUMERIC"
      "LC_TIME"
      "LC_COLLATE"
      "LC_MONETARY"
      "LC_MESSAGES"
      "LC_PAPER"
      "LC_NAME"
      "LC_ADDRESS"
      "LC_TELEPHONE"
      "LC_MEASUREMENT"
      "LC_IDENTIFICATION"
      "LC_ALL"
      "LANG"
    ]
  );

  # Read-only bind-mounts a `{ source, target }` file into `~`.
  mount-home-file = fileEntry: ro-bind fileEntry.source (noescape "~/${fileEntry.target}");

  # Read-only bind-mounts all entries under `dirName` into `~`.
  mount-home-dir =
    fileEntrySet: dirName:
    fileEntrySet
    |> lib.filterAttrs (n: _: lib.hasPrefix "${lib.removeSuffix "/" dirName}/" n)
    |> lib.mapAttrsToList (_: v: ro-bind v.source (noescape "~/${v.target}"))
    |> compose;

  # Wires up the host Nix daemon and forwards Nix config files.
  nix-daemon = compose [
    (add-pkg-deps [ pkgs.nix ])
    (readwrite "/nix/var/nix/daemon-socket")
    (set-env "NIX_REMOTE" "daemon")
    (try-fwd-env "NIX_PATH")
    ("/etc/nix/nix.conf" |> try-readonly |> defer)
    ("/etc/nix/registry.json" |> try-readonly |> defer)
    (noescape "~/.config/nix/nix.conf" |> try-readonly |> defer)
    (noescape "~/.config/nix/registry.json" |> try-readonly |> defer)
  ];

  # Like readonly-paths-from-var, but also rewrites the variable to the
  # resolved paths. This matters for variables such as XDG_DATA_DIRS
  # whose entries may be symlinks (profiles) that do not exist inside
  # the jail.
  resolved-paths-from-var =
    var: separator:
    compose [
      (add-runtime ''
        IFS=${lib.escapeShellArg separator} read -ra RESOLVED_DIRS <<< "''${${var}-}"
        if ((''${#RESOLVED_DIRS[@]})); then
          RESOLVED=()
          while IFS= read -r -d "" dir; do
            already_seen=0
            for existing in "''${RESOLVED[@]}"; do
              if [ "$existing" = "$dir" ]; then
                already_seen=1
                break
              fi
            done
            if [ "$already_seen" = 0 ]; then
              RUNTIME_ARGS+=(--ro-bind "$dir" "$dir")
              RESOLVED+=("$dir")
            fi
          done < <(realpath -ezq -- "''${RESOLVED_DIRS[@]}")
          if ((''${#RESOLVED[@]})); then
            RUNTIME_ARGS+=(--setenv ${var} "$(IFS=${lib.escapeShellArg separator}; printf '%s' "''${RESOLVED[*]}")")
          fi
        fi
      '')
    ];

  # Grants DBus access to the Secret Service (keyring).
  secret-service = dbus { talk = [ "org.freedesktop.secrets" ]; };

  # Sets the jail's app id (and `$FLATPAK_ID`); may only be used once.
  set-app-id =
    appId:
    compose [
      (
        state:
        lib.throwIf (state ? appId) "Cannot use `set-app-id` more than once" (state // { inherit appId; })
      )
      (set-env "FLATPAK_ID" appId)
    ];

  # Mounts a shared `$TMPDIR` / `/tmp` for all instances with the same `appId`
  shared-tmp =
    state:
    let
      hostPath = runDirSubPath state "tmp";
      path = "\"\${TMPDIR:-/tmp}\"";
    in
    compose [
      (add-runtime "mkdir -p ${hostPath}")
      (rw-bind (noescape hostPath) (noescape path))
      (set-env "TMPDIR" (noescape path))
    ] state;

  # Mounts a shared `$XDG_RUNTIME_DIR` for all instances with the same `appId`
  shared-run =
    state:
    let
      hostPath = runDirSubPath state "run";
      path = "\"\${XDG_RUNTIME_DIR:-/run/user/$UID}\"";
    in
    compose [
      (add-runtime "mkdir -p ${hostPath}")
      (rw-bind (noescape hostPath) (noescape path))
      (set-env "XDG_RUNTIME_DIR" (noescape path))
    ] state;

  # Forwards `$SSH_AUTH_SOCK` and binds the agent socket read-write.
  ssh-agent = compose [
    (fwd-env "SSH_AUTH_SOCK")
    (readwrite (noescape "\"$SSH_AUTH_SOCK\""))
  ];

  # Lets the app register a system tray icon over DBus.
  sys-tray = dbus {
    talk = [
      "com.canonical.indicator.application"
      "org.ayatana.indicator.application"
      "org.kde.StatusNotifierWatcher"
    ];
  };

  # Persists a per-app directory under `~/.app/<appId>/` read-write.
  persist =
    dir: state:
    let
      path = appDirSubPath state dir;
    in
    compose [
      (add-runtime "mkdir -p ${path}")
      (readwrite (noescape path))
    ] state;

  # Persists and redirects the XDG base dirs to per-app directories.
  persist-base-dirs =
    state:
    compose (
      lib.mapAttrsToList (
        n: v:
        let
          jailPath = appDirSubPath state n;
        in
        [
          (add-runtime "mkdir -p ${jailPath}")
          (rw-bind (noescape jailPath) (noescape v.path))
          (set-env v.var (noescape v.path))
        ]
      ) xdgBaseDirs
      |> lib.flatten
    ) state;

  # Returns a path expression for an XDG base dir (`config`, `data`, `state`, `cache`).
  xdg-base-dir = name: noescape xdgBaseDirs.${name}.path;

  # Resolves an XDG user directory such as `download` at runtime.
  xdg-user-dir =
    name:
    noescape "\"$(${lib.getExe' pkgs.xdg-user-dirs "xdg-user-dir"} ${
      lib.toUpper name |> lib.escapeShellArg
    })\"";
}
