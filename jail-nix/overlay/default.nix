combinators: pkgs:

with combinators; {
  diebahn = [
    gui-enhanced
    network
    open-urls-in-browser
    (desktop-portal "de.schmidhuberj.DieBahn")
  ];
  telegram-desktop =
    let
      id = "org.telegram.desktop";
    in
    [
      (persist-home id)
      gui-enhanced
      network
      sys-tray
      notifications
      (desktop-portal id)
    ];
}
