{
  config,
  lib,
  ...
}: let
  inherit (lib.slashfiles.mkMod config ./.) mkConfig;
in {
  config = mkConfig {
    services.hyprpaper.enable = true;
    services.hyprpaper.settings = {
      ipc = "on";
      splash = false;
      preload = [
        "${config.home.homeDirectory}/wallpapers/primary"
        "${config.home.homeDirectory}/wallpapers/secondary"
      ];

      wallpaper = [
        "eDP-1, ${lib.elemAt config.services.hyprpaper.settings.preload 0}"
        "DP-2, ${lib.elemAt config.services.hyprpaper.settings.preload 1}"
      ];
    };
  };
}
