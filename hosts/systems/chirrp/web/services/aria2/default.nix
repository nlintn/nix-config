{
  ...
}:

{
  imports = [
    ./vpn.nix
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    ariang = pkgs.ariang.overrideAttrs (prev: {
      patches = prev.patches or [ ] ++ [
        ./0001-adjust-default-option-values.patch
      ];
    });
  };
}
