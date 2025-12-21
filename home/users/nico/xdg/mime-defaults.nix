{ config, lib, osConfig ? null, ... }:

let
  f = t: p: lib.genAttrs t (_: p);

  chromium = lib.mkIf config.programs.chromium.enable "chromium-browser.desktop";
  desmume = "org.desmume.DeSmuME.desktop";
  firefox = lib.mkIf config.programs.firefox.enable config.programs.firefox.finalPackage.desktopItem.name;
  font-viewer = "com.github.FontManager.FontViewer.desktop";
  ghostty = lib.mkIf config.programs.ghostty.enable "ghostty.desktop";
  gimp = "gimp.desktop";
  keepassxc = lib.mkIf config.programs.keepassxc.enable "org.keepassxc.KeePassXC.desktop";
  kitty = lib.mkIf config.programs.kitty.enable "kitty.desktop";
  mpv = lib.mkIf config.programs.mpv.enable "mpv.desktop";
  neovim = lib.mkIf (config.vars ? nvimPackage) "nvim.desktop";
  papers = "org.gnome.Papers.desktop";
  pdf-arranger = "com.github.jeromerobert.pdfarranger.desktop";
  prusa-gcode-viewer = "PrusaGcodeviewer.desktop";
  prusa-slicer = "PrusaSlicer.desktop";
  showtime = "org.gnome.showtime.desktop";
  swayimg = lib.mkIf config.programs.swayimg.enable "swayimg.desktop";
  thunar = lib.mkIf config.programs.thunar.enable "thunar.desktop";
  thunderbird = lib.mkIf config.programs.thunderbird.enable config.programs.thunderbird.package.desktopItem.name;
  wireshark = "org.wireshark.Wireshark.desktop";
  yazi = lib.mkIf config.programs.yazi.enable "yazi.desktop";
  zathura = lib.mkIf config.programs.zathura.enable "org.pwmt.zathura.desktop";

in lib.mergeAttrsList [
  # audio
  (f [
    "audio/basic"
    "audio/x-musepack"
    "audio/x-wavpack"
    "audio/x-adpcm"
    "audio/x-scpls"
    "audio/vnd.dts.hd"
    "audio/x-gsm"
    "audio/vnd.wave"
    "audio/x-s3m"
    "audio/ac3"
    "audio/mpeg"
    "audio/x-tta"
    "audio/x-matroska"
    "audio/x-mod"
    "audio/x-mpegurl"
    "audio/x-ms-wma"
    "audio/x-aiff"
    "audio/AMR"
    "audio/x-it"
    "audio/x-ape"
    "audio/vnd.rn-realaudio"
    "audio/ogg"
    "audio/midi"
    "audio/vnd.dts"
    "audio/x-ms-asx"
    "audio/x-vorbis+ogg"
    "audio/flac"
    "audio/mp2"
    "audio/x-speex"
    "audio/webm"
    "audio/mp4"
    "audio/aac"
    "audio/x-xm"
    "audio/AMR-WB"
  ] [
    mpv
  ])

  # browsers
  (f [
    "text/html"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/chrome"
    "x-scheme-handler/about"
    "x-scheme-handler/unknown"
    "application/x-extension-htm"
    "application/x-extension-html"
    "application/x-extension-shtml"
    "application/xhtml+xml"
    "application/x-extension-xhtml"
    "application/x-extension-xht"
  ] [
    firefox
    chromium
  ])

  # documents
  (f [
    "application/pdf"
    "application/postscript"
  ] [
    zathura
    papers
    pdf-arranger
  ])

  # directories
  (f [
    "inode/directory"
  ] [
    thunar
    yazi
  ])

  # fonts
  (f [
    "font/ttf"
    "font/ttc"
    "font/otf"
    "font/sfnt"
    "application/x-font-ttf"
    "application/x-font-otf"
    "application/vnd.ms-opentype"
  ] [
    font-viewer
  ])

  # images
  (f [
    "image/webp"
    "image/gif"
    "image/vnd.wap.wbmp"
    "image/x-portable-graymap"
    "image/x-tga"
    "image/x-xpixmap"
    "image/svg+xml"
    "image/tiff"
    "image/vnd.microsoft.icon"
    "image/x-portable-bitmap"
    "image/x-portable-anymap"
    "image/x-portable-pixmap"
    "image/jpeg"
    "image/bmp"
    "image/vnd.zbrush.pcx"
    "image/x-xbitmap"
    "image/x-icns"
    "image/svg+xml-compressed"
    "image/png"
  ] [
    swayimg
    gimp
  ])

  # mails
  (f [
    "message/rfc822"
  ] [
    thunderbird
  ])

  # 3D models
  (f [
    "model/3mf"
    "model/stl"
    "model/step"
    "model/step+xml"
    "model/step+zip"
    "model/step-xml+zip"
  ] [
    prusa-slicer
  ])

  # packetCaptures
  (f [
    "application/ipfix"
    "application/x-nettl"
    "application/x-lanalyzer"
    "application/x-snoop"
    "application/x-pcapng"
    "application/x-apple-packetlogger"
    "application/x-endace-erf"
    "application/x-iptrace"
    "application/x-netinstobserver"
    "application/x-micropross-mplog"
    "application/x-radcom"
    "application/x-ixia-vwr"
    "application/x-etherpeek"
    "application/vnd.tcpdump.pcap"
    "application/x-tektronix-rf5"
    "application/x-visualnetworks"
    "application/x-5view"
  ] [
    wireshark
  ])

  # terminal
  (f [
    "x-scheme-handler/terminal"
  ] [
    ghostty
    kitty
  ])

  # texts
  (f [
    "text/calendar"
    "text/csv"
    "text/plain"
    "application/x-shellscript"
    "application/x-zerosize"
    "application/xml"
  ] [
    neovim
  ])

  # videos
  (f [
    "video/3gpp2"
    "video/vnd.avi"
    "video/x-flv"
    "video/x-anim"
    "video/mpeg"
    "video/dv"
    "video/vnd.rn-realvideo"
    "video/3gpp"
    "video/ogg"
    "video/x-ogm+ogg"
    "video/x-matroska"
    "video/vnd.mpegurl"
    "video/quicktime"
    "video/x-ms-wmv"
    "video/mp4"
    "video/webm"
    "video/x-flic"
    "video/x-theora+ogg"
    "video/mp2t"
    "video/x-nsv"
  ] [
    showtime
    mpv
  ])

  # media
  (f [
    "x-content/audio-cdda"
    "x-content/video-svcd"
    "x-content/video-vcd"
    "x-content/video-dvd"
    "x-content/audio-player"
  ] [
    showtime
    mpv
  ])

  # keepass
  (f [
    "application/x-keepass2"
  ] [
    keepassxc
  ])

  # ds-rom
  (f [
    "application/x-nintendo-ds-rom"
  ] [
    desmume
  ])

  # gcode
  (f [
    "application/x-bgcode"
  ] [
    prusa-gcode-viewer
  ])

  # xfc
  (f [
    "image/x-xcf"
  ] [
    gimp
  ])
]
