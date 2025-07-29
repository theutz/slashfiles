{ config, pkgs, lib, namespace, ... }@args: let
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

    xdg.configFile."hypr" = {
      source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${namespace}/nix/modules/home/${mod}/hypr";
      force = true;
      recursive = false;
    };

    programs.wofi.enable = true;
  };
}
