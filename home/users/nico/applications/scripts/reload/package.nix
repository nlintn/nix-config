{
  lib,
  inputs,
  config,
  git,
  home-manager,
  nixos-rebuild-nom,
  osConfig ? null,
  writeShellScriptBin,
  ...
}:

let
  configDirectory = lib.escapeShellArg config.home.sessionVariables.NIX_CONFIG_DIR;
  inputOverrides = lib.optionalString config.common.setNixRegistry "$(${lib.getExe git} diff --quiet ${configDirectory}/flake.lock \"$(self=\"$(${lib.getExe config.nix.package} registry resolve self)\" && builtin echo \"\${self#path:}\")\" && builtin echo ${
    lib.mapAttrsToList (n: _: lib.optionalString (n != "self") "--override-input ${n} ${n}") inputs
    |> lib.concatStringsSep " "
  })";
in
writeShellScriptBin "reload" (
  if osConfig.system.tools.nixos-rebuild.enable or false && config.submoduleSupport.enable then
    /* sh */ ''
      ${lib.getExe nixos-rebuild-nom} switch --flake ${configDirectory} "${inputOverrides}" --elevate run0 $@
    ''
  else if config.programs.home-manager.enable && !config.submoduleSupport.enable then
    /* sh */ ''
      ${lib.getExe home-manager} switch --flake ${configDirectory} "${inputOverrides}" $@
    ''
  else
    /* sh */ ''
      builtin echo 'No reload functionality on this system!'
    ''
)
