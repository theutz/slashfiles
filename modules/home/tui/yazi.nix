{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib.${namespace}.mkMod config ./.) mkConfig;
in
{
  config = mkConfig {
    programs.yazi.enable = true;
  };
}
