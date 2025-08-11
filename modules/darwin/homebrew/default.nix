{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkMod;
in
mkMod {
  homebrew.enable = true;

  system.primaryUser = lib.mkDefault lib.${namespace}.primaryUser;
}
