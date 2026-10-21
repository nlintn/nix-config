{
  pkgs,
  lib,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    arp-scan
    powertop
    psmisc
    tcpdump
  ];

  programs = {
    gdk-pixbuf.modulePackages = [ pkgs.librsvg ]; # else no svgs in gtk apps
    ausweisapp = {
      enable = true;
      openFirewall = true;
    };
    nix-ld.enable = true;
    steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
    wireshark.enable = true;
    xfconf.enable = true;
    zsh.enable = true;
  };
}
