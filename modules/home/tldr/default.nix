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
  programs.tealdeer = {
    enable = true;
    enableAutoUpdates = true;
  };
}
