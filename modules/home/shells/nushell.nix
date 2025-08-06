{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkConfig;
in
{
  config = mkConfig {
    programs.nushell.enable = true;
  };
}
