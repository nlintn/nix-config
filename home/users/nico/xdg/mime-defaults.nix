{
  config,
  lib,
  osConfig ? null,
  ...
}:

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
  nautilus = lib.mkIf config.programs.nautilus.enable "nautilus.desktop";
  neovim = lib.mkIf (config.vars ? nvimPackage) "nvim.desktop";
  papers = "org.gnome.Papers.desktop";
  pdf-arranger = "com.github.jeromerobert.pdfarranger.desktop";
  prusa-gcode-viewer = "PrusaGcodeviewer.desktop";
  prusa-slicer = "PrusaSlicer.desktop";
  showtime = "org.gnome.showtime.desktop";
  swayimg = lib.mkIf config.programs.swayimg.enable "swayimg.desktop";
  thunderbird = lib.mkIf config.programs.thunderbird.enable config.programs.thunderbird.package.desktopItem.name;
  wireshark = "org.wireshark.Wireshark.desktop";
  yazi = lib.mkIf config.programs.yazi.enable "yazi.desktop";
  zathura = lib.mkIf config.programs.zathura.enable "org.pwmt.zathura.desktop";

in
lib.mergeAttrsList [
  # audio
  (f
    [
      "audio/AMR"
      "audio/AMR-WB"
      "audio/aac"
      "audio/ac3"
      "audio/basic"
      "audio/flac"
      "audio/midi"
      "audio/mp2"
      "audio/mp4"
      "audio/mpeg"
      "audio/ogg"
      "audio/vnd.dts"
      "audio/vnd.dts.hd"
      "audio/vnd.rn-realaudio"
      "audio/vnd.wave"
      "audio/webm"
      "audio/x-adpcm"
      "audio/x-aiff"
      "audio/x-ape"
      "audio/x-gsm"
      "audio/x-it"
      "audio/x-matroska"
      "audio/x-mod"
      "audio/x-mpegurl"
      "audio/x-ms-asx"
      "audio/x-ms-wma"
      "audio/x-musepack"
      "audio/x-s3m"
      "audio/x-scpls"
      "audio/x-speex"
      "audio/x-tta"
      "audio/x-vorbis+ogg"
      "audio/x-wavpack"
      "audio/x-xm"
    ]
    [
      mpv
    ]
  )

  # browsers
  (f
    [
      "application/x-extension-htm"
      "application/x-extension-html"
      "application/x-extension-shtml"
      "application/x-extension-xht"
      "application/x-extension-xhtml"
      "application/xhtml+xml"
      "text/html"
      "x-scheme-handler/about"
      "x-scheme-handler/chrome"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/unknown"
    ]
    [
      firefox
      chromium
    ]
  )

  # calendars
  (f
    [
      "text/calendar"
    ]
    [
      thunderbird
    ]
  )

  # documents
  (f
    [
      "application/pdf"
      "application/postscript"
    ]
    [
      zathura
      papers
      pdf-arranger
    ]
  )

  # directories
  (f
    [
      "inode/directory"
    ]
    [
      nautilus
      yazi
    ]
  )

  # fonts
  (f
    [
      "application/vnd.ms-opentype"
      "application/x-font-otf"
      "application/x-font-ttf"
      "font/otf"
      "font/sfnt"
      "font/ttc"
      "font/ttf"
    ]
    [
      font-viewer
    ]
  )

  # images
  (f
    [
      "image/bmp"
      "image/gif"
      "image/jpeg"
      "image/png"
      "image/svg+xml"
      "image/svg+xml-compressed"
      "image/tiff"
      "image/vnd.microsoft.icon"
      "image/vnd.wap.wbmp"
      "image/vnd.zbrush.pcx"
      "image/webp"
      "image/x-icns"
      "image/x-portable-anymap"
      "image/x-portable-bitmap"
      "image/x-portable-graymap"
      "image/x-portable-pixmap"
      "image/x-tga"
      "image/x-xbitmap"
      "image/x-xpixmap"
    ]
    [
      swayimg
      gimp
    ]
  )

  # mails
  (f
    [
      "message/rfc822"
      "x-scheme-handler/mailto"
      "x-scheme-handler/mid"
    ]
    [
      thunderbird
    ]
  )

  # 3D models
  (f
    [
      "model/3mf"
      "model/step"
      "model/step+xml"
      "model/step+zip"
      "model/step-xml+zip"
      "model/stl"
    ]
    [
      prusa-slicer
    ]
  )

  # packetCaptures
  (f
    [
      "application/ipfix"
      "application/vnd.tcpdump.pcap"
      "application/x-5view"
      "application/x-apple-packetlogger"
      "application/x-endace-erf"
      "application/x-etherpeek"
      "application/x-iptrace"
      "application/x-ixia-vwr"
      "application/x-lanalyzer"
      "application/x-micropross-mplog"
      "application/x-netinstobserver"
      "application/x-nettl"
      "application/x-pcapng"
      "application/x-radcom"
      "application/x-snoop"
      "application/x-tektronix-rf5"
      "application/x-visualnetworks"
    ]
    [
      wireshark
    ]
  )

  # terminal
  (f
    [
      "x-scheme-handler/terminal"
    ]
    [
      ghostty
      kitty
    ]
  )

  # texts
  (f
    [
      "application/json"
      "application/x-shellscript"
      "application/x-zerosize"
      "application/xml"
      "text/csv"
      "text/plain"
    ]
    [
      neovim
    ]
  )

  # videos
  (f
    [
      "video/3gpp"
      "video/3gpp2"
      "video/dv"
      "video/mp2t"
      "video/mp4"
      "video/mpeg"
      "video/ogg"
      "video/quicktime"
      "video/vnd.avi"
      "video/vnd.mpegurl"
      "video/vnd.rn-realvideo"
      "video/webm"
      "video/x-anim"
      "video/x-flic"
      "video/x-flv"
      "video/x-matroska"
      "video/x-ms-wmv"
      "video/x-nsv"
      "video/x-ogm+ogg"
      "video/x-theora+ogg"
    ]
    [
      showtime
      mpv
    ]
  )

  # media
  (f
    [
      "x-content/audio-cdda"
      "x-content/audio-player"
      "x-content/video-dvd"
      "x-content/video-svcd"
      "x-content/video-vcd"
    ]
    [
      showtime
      mpv
    ]
  )

  # keepass
  (f
    [
      "application/x-keepass2"
    ]
    [
      keepassxc
    ]
  )

  # ds-rom
  (f
    [
      "application/x-nintendo-ds-rom"
    ]
    [
      desmume
    ]
  )

  # gcode
  (f
    [
      "application/x-bgcode"
    ]
    [
      prusa-gcode-viewer
    ]
  )

  # xfc
  (f
    [
      "image/x-xcf"
    ]
    [
      gimp
    ]
  )
]
