{
  config,
  lib,
  osConfig ? null,
  pkgs,
  ...
}:

{
  imports = [
    ./packages.nix

    ./bat.nix
    ./element-desktop.nix
    ./firefox
    ./fzf.nix
    ./gdb.nix
    ./ghostty
    ./git.nix
    ./gpg.nix
    ./keepassxc
    ./lazygit.nix
    ./less.nix
    ./neovim.nix
    ./obs-studio.nix
    ./ssh.nix
    ./thunar.nix
    ./thunderbird.nix
    ./tmux
    ./yazi.nix
    ./zathura.nix
  ];

  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    commandLineArgs = [
      "--no-default-browser-check"
      "--password-store=basic"
    ];
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.man = {
    enable = true;
    generateCaches = true;
  };
  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };

  programs = {
    anki.enable = true;
    fastfetch.enable = true;
    fd.enable = true;
    htop.enable = true;
    java.enable = true;
    jq.enable = true;
    mpv.enable = true;
    rclone.enable = true;
    ripgrep.enable = true;
    swayimg.enable = true;
    vesktop.enable = true;
  };

  services.kdeconnect = {
    enable = true;
    indicator = true;
    package = lib.mkIf (osConfig != null) osConfig.programs.kdeconnect.package;
  };
  services.protonmail-bridge = {
    enable = true;
    enableCfgScript = true;
    extraPackages = [ config.programs.keepassxc.package ];
  };
  services.taildrop-receive = {
    enable = true;
    package = lib.mkIf (osConfig != null) osConfig.services.tailscale.package;
    directory = "${config.xdg.userDirs.download}/taildrop";
  };
  services.tailscale-systray = {
    enable = true;
    package = lib.mkIf (osConfig != null) osConfig.services.tailscale.package;
  };

  services = {
    playerctld.enable = true;
    podman.enable = true;
    systembus-notify.enable = true;
    tumbler.enable = true;
  };
}
