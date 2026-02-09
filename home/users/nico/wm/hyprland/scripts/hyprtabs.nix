{
  bashInteractive,
  config,
  jq,
  writeShellApplication,
  ...
}:

writeShellApplication {
  name = "hyprtabs";
  runtimeInputs = [
    bashInteractive
    config.wayland.windowManager.hyprland.finalPackage
    jq
  ];
  text = "bash --posix ${
    builtins.fetchGit {
      url = "https://gist.github.com/b08c5b67172abafa5e7286f4a952ca4d.git";
      rev = "cf8256399c4c2087a2bc70dd7eb8c5e9ed663003";
      narHash = "sha256-GWEjm10JnbDezxaPPFUS9+gNvtDHL34piyk2OvS5o+Q=";
    }
    + "/hyprtabs.sh"
  }";
}
