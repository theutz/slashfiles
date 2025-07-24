{
  config,
  pkgs,
  lib,
  namespace,
  ...
}: let
  mod = builtins.baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  imports = [
    ./waybar.nix
    ./wofi.nix
  ];

  options.${namespace}.${mod} = {
    enable = lib.mkEnableOption "enable ${mod}";

    monitor = lib.mkOption {
      type = with lib.types; listOf str;
      description = ''
        List of monitors for hyprland to setup
      '';
      default = [", preferred, auto, auto"];
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      kitty
      kdePackages.dolphin
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      settings = import ./settings.nix {inherit (cfg) monitor;};
    };

    services.dunst.enable = true;
  };
}
