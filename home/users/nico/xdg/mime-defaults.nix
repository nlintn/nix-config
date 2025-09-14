{ config, lib, osConfig ? null, ... }:

let
  f = t: p: lib.genAttrs t (_: p);

  chromium = lib.mkIf config.programs.chromium.enable "chromium-browser.desktop";
  desmume = "org.desmume.DeSmuME.desktop";
  evince = lib.mkIf config.programs.evince.enable "org.gnome.Evince.desktop";
  firefox = lib.mkIf config.programs.firefox.enable config.programs.firefox.finalPackage.desktopItem.name;
  gimp = "gimp.desktop";
  image-roll = "com.github.weclaw1.ImageRoll.desktop";
  keepassxc = lib.mkIf config.programs.keepassxc.enable "org.keepassxc.KeePassXC.desktop";
  neovim = lib.mkIf (config.home.sessionVariables ? NVIM) "nvim.desktop";
  pdf-arranger = "com.github.jeromerobert.pdfarranger.desktop";
  prusa-slicer = "PrusaSlicer.desktop";
  prusa-gcode-viewer = "PrusaGcodeviewer.desktop";
  swayimg = "swayimg.desktop";
  thunar = lib.mkIf config.programs.thunar.enable "thunar.desktop";
  thunderbird = lib.mkIf config.programs.thunderbird.enable config.programs.thunderbird.package.desktopItem.name;
  vlc = "vlc.desktop";
  wireshark = "org.wireshark.Wireshark.desktop";
  yazi = lib.mkIf config.programs.yazi.enable "yazi.desktop";
  zathura = lib.mkIf config.programs.zathura.enable "org.pwmt.zathura.desktop";

  audios = f [
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
    vlc
  ];

  browsers = f [
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
  ];

  documents = f [
    "application/pdf"
    "application/postscript"
  ] [
    zathura
    evince
    pdf-arranger
  ];
  
  folders = f [
    "inode/directory"
  ] [
    thunar
    yazi
  ];

  images = f [
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
    image-roll
    swayimg
  ];

  mails = f [
    "message/rfc822"
  ] [
    thunderbird
  ];

  models3d = f [
    "model/3mf"
    "model/stl"
  ] [
    prusa-slicer
  ];

  packetCaptures = f [
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
  ];

  texts = f [
    "text/calendar"
    "text/csv"
    "text/plain"
    "text/html"
    "application/x-shellscript"
    "application/xml"
  ] [
    neovim
  ];

  videos = f [
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
    vlc
  ];

  media = f [
    "x-content/audio-cdda"
    "x-content/video-svcd"
    "x-content/video-vcd"
    "x-content/video-dvd"
    "x-content/audio-player"
  ] [
    vlc
  ];

  extraSettings = {
    "application/x-keepass2" = keepassxc;
    "application/x-nintendo-ds-rom" = desmume;
    "application/x-bgcode" = prusa-gcode-viewer;
    "image/x-xcf" = gimp;
  };

in
  (lib.mergeAttrsList [
    audios
    browsers
    documents
    folders
    images
    mails
    models3d
    packetCaptures
    texts
    videos
    media
  ]) // extraSettings
