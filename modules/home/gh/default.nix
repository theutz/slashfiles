{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkMod;
in
mkMod {
  programs.gh.enable = true;
}
