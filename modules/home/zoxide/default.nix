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
  programs.zoxide.enable = true;
  home.shellAliases.ze = "zoxide edit";
}
