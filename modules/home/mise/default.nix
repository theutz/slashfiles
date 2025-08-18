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
  programs.mise.enable = true;
  programs.direnv.mise.enable = true;
}
