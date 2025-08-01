{
  lib,
  config,
  ...
}: let
  inherit (lib.slashfiles.mkMod config ./.) mkConfig;
in {
  config = mkConfig {
    programs.tealdeer = {
      enable = true;
      enableAutoUpdates = true;
    };
  };
}
