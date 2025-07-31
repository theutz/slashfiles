{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.slashfiles.mkMod config ./.) mkConfig;
in {
  config = mkConfig {
    home.packages = with pkgs; [
      bluetui
      bluetuith
    ];

    xdg.desktopEntries = {
      bluetooth = {
        name = "Bluetooth Controls";
        exec = lib.getExe pkgs.bluetui;
        terminal = true;
        actions = {
          bluetuith = {
            name = "Open Bluetuith";
            exec = lib.getExe pkgs.bluetuith;
          };
        };
      };
    };
  };
}
