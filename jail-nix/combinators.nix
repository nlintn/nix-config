{
  lib,
  pkgs,
}:

combinators: with combinators; rec {
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
    (add-runtime "mkdir -p ~/.config/dconf")
    pulse
    pipewire
    wayland
    (runtime-deep-ro-bind (noescape "/etc/fonts"))
    (readonly (noescape "~/.config/dconf"))
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
    (try-readonly (noescape "~/.config/gtk-2.0"))
    (try-readonly (noescape "~/.config/gtk-3.0"))
    (try-readonly (noescape "~/.config/gtk-4.0"))
    (try-readonly (noescape "~/.icons"))
    (try-fwd-env "QT_QPA_PLATFORMTHEME")

    (try-fwd-env "GTK_A11Y")
    locale
  ];
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
  printing = dbus {
    talk = [
      "org.freedesktop.portal.Print"
      "org.freedesktop.portal.Desktop"
    ];
  };
  secret-service = dbus { talk = [ "org.freedesktop.secrets" ]; };
  shared-tmp =
    name:
    let
      path = "\"\${XDG_RUNTIME_DIR:-\"/tmp\"}\"/jail.nix/tmp/${lib.escapeShellArg name}";
    in
    compose [
      (add-runtime "mkdir -p ${path}")
      (rw-bind (noescape path) "/tmp")
    ];
  ssh-agent = compose [
    (fwd-env "SSH_AUTH_SOCK")
    (readwrite (noescape "\"$SSH_AUTH_SOCK\""))
  ];
  sys-tray = dbus { talk = [ "org.kde.StatusNotifierWatcher" ]; };
}
