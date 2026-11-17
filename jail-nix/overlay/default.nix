pkgs: combinators:

with combinators; {
  diebahn = [
    (base-xdg "de.schmidhuberj.DieBahn")
    gui-enhanced
    network
  ];
  telegram-desktop = [
    (base-xdg "org.telegram.desktop")
    persist-base-dirs
    gui-enhanced
    network
    sys-tray
    notifications
    (readwrite (xdg-user-dir "download"))
  ];
  pdfarranger = [
    (base-xdg "com.github.jeromerobert.pdfarranger")
    shared-tmp
    (readwrite (noescape "~"))
    persist-base-dirs
    gui-enhanced
    readwrite-runtime-args
  ];
}
