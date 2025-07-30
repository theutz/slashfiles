{
  config,
  pkgs,
  lib,
  namespace,
  ...
} @ args: let
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

    workspaces = lib.mkOption {
      type = with lib.types; int;
      description = ''
        How many persistent workspaces to create.
      '';
      default = 5;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      kitty
      kdePackages.dolphin
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      settings = import ./settings.nix (args // {inherit cfg;});
    };

    services.dunst.enable = true;
  };
}
