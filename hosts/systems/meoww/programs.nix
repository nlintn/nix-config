{ pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    man-pages linux-manual man-pages-posix

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
    captive-browser = {
      enable = true;
      browser = lib.concatStringsSep " " [
        ''env XDG_CONFIG_HOME="$PREV_CONFIG_HOME"''
        ''${lib.getExe pkgs.ungoogled-chromium}''
        ''--user-data-dir=''${XDG_DATA_HOME:-$HOME/.local/share}/chromium-captive''
        ''--proxy-server="socks5://$PROXY"''
        ''--proxy-bypass-list="<-loopback>"''
        ''--no-first-run''
        ''--new-window''
        ''--incognito''
        ''--no-default-browser-check''
        ''--no-crash-upload''
        ''--disable-extensions''
        ''--disable-sync''
        ''--disable-background-networking''
        ''--disable-client-side-phishing-detection''
        ''--disable-component-update''
        ''--disable-translate''
        ''--disable-web-resources''
        ''--safebrowsing-disable-auto-update''
        ''http://cache.nixos.org/''
      ];
      interface = "wlan0";
    };
    kdeconnect.enable = true;
    # nix-ld.enable = true;
    steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
    wireshark.enable = true;
    xfconf.enable = true;
    zsh.enable = true;
  };
}
