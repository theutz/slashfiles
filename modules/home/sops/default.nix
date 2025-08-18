{
  lib,
  namespace,
  config,
  pkgs,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkMod;
in
mkMod {
  home.packages = with pkgs; [ sops ];
}
