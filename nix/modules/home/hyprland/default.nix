{
  config,
  pkgs,
  lib,
  ...
} @ args: let
  inherit (lib.slashfiles.mkMod config ./.) mkConfig mkOptions cfg;
in {
  imports = [
    ./waybar.nix
    ./wofi.nix
    ./settings.nix
  ];

  options = mkOptions {
    monitor = lib.mkOption {
      type = with lib.types; listOf str;
      description = ''
        List of monitors for hyprland to setup
      '';
      default = [", preferred, auto, auto"];
    };

    workspaces = lib.mkOption {
      type = with lib.types; int;
      description = ''
        How many persistent workspaces to create.
      '';
      default = 10;
    };
  };

  config = mkConfig {
    home.packages = with pkgs; [
      kitty
      kdePackages.dolphin
      playerctl
      brightnessctl
      wireplumber
    ];

    wayland.windowManager.hyprland.enable = true;

    services.dunst.enable = true;
  };
}
