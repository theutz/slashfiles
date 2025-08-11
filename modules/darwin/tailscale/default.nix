{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkMod;
in
mkMod {
  assertions = [
    {
      assertion = config.homebrew.enable;
      message = "You've gotta turn on homebrew to use tailscale on darwin.";
    }
  ];

  homebrew.enable = true;
  homebrew.casks = [ "tailscale" ];

  # services.tailscale.enable = true;
  # services.tailscale.overrideLocalDns = true;

  networking.dns = lib.mkDefault [
    "1.1.1.1"
    "1.0.0.1"
    "8.8.8.8"
    "8.8.4.4"
  ];

  networking.knownNetworkServices = lib.mkDefault [
    "Wi-Fi"
    "Thunderbolt Bridge"
    "USB 10/100/1000 LAN"
  ];
}
