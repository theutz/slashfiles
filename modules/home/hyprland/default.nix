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
  ];

  options.${namespace}.${mod}.enable = lib.mkEnableOption "enable ${mod}";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      wofi
      kitty
      kdePackages.dolphin
      dunst
      pipewire
      wireplumber
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      settings = import ./settings.nix;
    };
  };
}
