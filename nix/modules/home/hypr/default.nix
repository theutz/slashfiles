{ config, pkgs, lib, namespace, ... }: let
  inherit (builtins) baseNameOf;
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};
  inherit (lib) mkIf mkEnableOption;
  inherit (config.lib.file) mkOutOfStoreSymlink;
in {
  options.${namespace}.${mod}.enable = mkEnableOption "enable ${mod}";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      wezterm
      kitty
      playerctl
      brightnessctl
    ];

    services.dunst.enable = true;

    # wayland.windowManager.hyprland.enable = true;

    xdg.configFile."hypr/hyprland.conf".source = mkOutOfStoreSymlink ./hyprland.conf;

    programs.wofi.enable = true;
  };
}
