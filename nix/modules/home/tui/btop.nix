{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.mkMod config ./.) mkConfig;
in
{
  config = mkConfig {
    programs.btop.enable = true;
  };
}
