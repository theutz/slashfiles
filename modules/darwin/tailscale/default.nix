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
  services.tailscale.enable = true;
}
