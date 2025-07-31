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
        name = "Bluetooth";
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
