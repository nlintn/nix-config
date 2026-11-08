{
  config,
  lib,
  ...
}:

{
  networking = {
    nat = {
      enable = true;
      enableIPv6 = true;
      internalInterfaces = [ "ve-*" ];
      externalInterface = "enp0s25";
    };
    # allow containers to use resolver
    firewall.interfaces."ve-*".allowedUDPPorts = [ 53 ];
  };

  vars.containerSettings =
    let
      cfg = config.vars.containerSettings;
    in
    {
      prefix4 = "192.168.100.";
      prefix6 = "fc00::";
      hostAddress = cfg.prefix4 + "254";
      hostAddress6 = cfg.prefix6 + lib.toHexString 254;
      ids = lib.mapAttrs (
        n: _:
        let
          finalId = cfg.ids.${n}.id;
        in
        {
          id =
            builtins.hashString "md5" n
            |> lib.substring 0 2
            |> lib.fromHexString
            |> (lib.flip lib.mod) 253
            |> lib.add 1
            |> lib.mkDefault;
          rootUID = 524288 + finalId * 65536;
          localAddress = cfg.prefix4 + toString finalId;
          localAddress6 = cfg.prefix6 + lib.toHexString finalId;
        }
      ) config.containers;
    };
  assertions = [
    {
      assertion =
        config.vars.containerSettings.ids
        |> lib.mapAttrs (_: v: v.id)
        |> lib.attrValues
        |> lib.allUnique;
      message = "container ids not unique";
    }
  ];
}
