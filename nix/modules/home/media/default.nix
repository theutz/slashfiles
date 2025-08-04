{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.mkMod config ./.) mkOptions mkConfig;
in
{
  imports = lib.${namespace}.list-other-files ./.;

  options = mkOptions { };

  config = mkConfig { };
}
