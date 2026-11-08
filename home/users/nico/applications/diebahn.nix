{
  jail,
  pkgs,
  ...
}:

{
  home.packages = [
    (jail pkgs.diebahn (
      with jail.combinators;
      [
        gui-enhanced
        network
        open-urls-in-browser

        (dbus {
          own = [
            "de.schmidhuberj.DieBahn"
          ];
        })
      ]
    ))
  ];
}
