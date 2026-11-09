jail-nix: pkgs:

let
  jail-nix-patched = import (pkgs.applyPatches {
    name = "source";
    src = jail-nix;
    patches = [ ./dbus-portal-id.patch ];
  }) { };

  lib = pkgs.lib;
  jail-unwrapped = jail-nix-patched.extend {
    inherit pkgs;
    additionalCombinators = import ./combinators.nix { inherit lib pkgs; };
    basePermissions =
      combinators: with combinators; [
        base
        (add-pkg-deps (with pkgs; [ xdg-utils ]))
        (readonly "/nix/store")
        fake-passwd
      ];
  };

  jail-wrapped = jail-unwrapped // {
    unwrapped = jail-unwrapped;
    overlay = import ./overlay jail-wrapped;
    __functor =
      self: pkg: jail-permissions:
      let
        # Don't jail recursively
        unjailed = pkg.unjailed or pkg;

        outputs = unjailed.outputs;

        # Wrap every file in bin/ and libexec/, preserving the directory it
        # originally lived in (e.g. bin/foo and libexec/foo/bar).
        jailDirs = [
          "bin"
          "libexec"
        ];

        exeEntries = lib.concatMap (
          o:
          lib.concatMap (
            dir:
            let
              dirPath = "${unjailed.${o}}/${dir}";
            in
            lib.optionals (lib.pathExists dirPath) (
              lib.map (exe: {
                inherit o exe;
                rel = lib.removePrefix "${unjailed.${o}}/" exe;
                name = lib.baseNameOf exe;
              }) (lib.filesystem.listFilesRecursive dirPath)
            )
          ) jailDirs
        ) outputs;

        jailedEntries = lib.map (
          entry:
          entry
          // {
            # Pass the specific file so each wrapper runs its own executable
            # rather than the package's meta.mainProgram.
            jailed = self.unwrapped entry.name entry.exe jail-permissions;
          }
        ) exeEntries;

        # Shell variable for the output corresponding to `o`, e.g. $out or $dev.
        outputVar = o: "$" + o;

        substitutions = lib.map (o: {
          from = toString unjailed.${o};
          to = outputVar o;
        }) outputs;

        outputDirs = lib.concatMapStringsSep " " (o: ''"${outputVar o}"'') outputs;
        grepPatterns = lib.concatMapStringsSep " " (s: "-e ${lib.escapeShellArg s.from}") substitutions;
        sedArgs = lib.concatMapStringsSep " " (
          s: ''-e "s|${lib.escapeRegex s.from}|${s.to}|g"''
        ) substitutions;

        jailed =
          pkgs.runCommandLocal unjailed.name
            {
              inherit (unjailed) meta outputs;
              passthru = unjailed.passthru // {
                inherit jailed unjailed jail-permissions;
              };
              # The result is only a tree of symlinks, so there is nothing to patch or strip.
              dontFixup = true;
            }
            ''
              ${lib.concatLines (
                lib.map (o: ''
                  mkdir -p "${outputVar o}"
                  ${lib.getExe pkgs.lndir} -silent ${unjailed.${o}} "${outputVar o}"
                '') outputs
              )}

              # Route each wrapped executable through its jail at the path it
              # originally occupied. This also handles libexec/ without exposing
              # those helpers in bin/.
              ${lib.concatLines (
                lib.map (e: ''
                  dst=${outputVar e.o}
                  mkdir -p "$dst"/${lib.escapeShellArg (lib.dirOf e.rel)}
                  ln -sfn ${lib.escapeShellArg "${e.jailed}/bin/${e.name}"} "$dst"/${lib.escapeShellArg e.rel}
                '') jailedEntries
              )}

              # Rewrite references to any output of the unjailed package in
              # launcher metadata to the matching output of this jail.
              while IFS= read -r -d "" file; do
                ${lib.getExe pkgs.gnused} -i \
                  ${sedArgs} \
                  "$file"
              done < <(
                for dir in ${outputDirs}; do
                  [ -d "$dir" ] || continue
                  ${lib.getExe pkgs.findutils} "$dir" \
                    \( -path "$dir/bin" -o -path "$dir/nix-support" \) -prune -o \
                    -xtype f \
                    \( -name '*.desktop' \
                       -o -path '*/dbus-1/services/*' \
                       -o -path '*/systemd/*' \) \
                    -print0
                done |
                ${lib.getExe' pkgs.findutils "xargs"} -0 -r \
                  ${lib.getExe pkgs.gnugrep} -FIlZ ${grepPatterns} -- \
                  || true
              )
            '';
      in
      jailed;
  };
in
jail-wrapped
