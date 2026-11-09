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

    ./scripts

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
    ./nautilus.nix
    ./neovim.nix
    ./nextcloud-sync.nix
    ./nix-search-tv.nix
    ./obs-studio.nix
    ./opencode
    ./ssh.nix
    ./swayimg.nix
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
    libreoffice.enable = true;
    mpv.enable = true;
    pgcli.enable = true;
    prismlauncher.enable = true;
    qalculate.enable = true;
    rclone.enable = true;
    ripgrep.enable = true;
    uv.enable = true;
    vesktop.enable = true;
  };

  services.batsignal = {
    enable = true;
    extraArgs = [
      "-d0"
      "-e"
      "-f0"
      "-m30"
      "-p"
    ];
  };
  services.kdeconnect = {
    enable = true;
    indicator = true;
    package = lib.mkIf (osConfig.services.kdeconnect.enable or false
    ) osConfig.programs.kdeconnect.package;
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
    usbguard-notifier.enable = true;
  };
}
