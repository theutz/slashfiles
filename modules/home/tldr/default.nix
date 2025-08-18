{
  lib,
  namespace,
  config,
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
