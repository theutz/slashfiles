{
  lib,
  config,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkConfig;
in
{
  config = mkConfig {
    programs.tealdeer = {
      enable = true;
      enableAutoUpdates = true;
    };
  };
}
