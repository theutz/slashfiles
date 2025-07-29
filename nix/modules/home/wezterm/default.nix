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
    ];

    xdg.configFile."wezterm" = {
      source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${namespace}/nix/modules/home/${mod}/wezterm";
      recursive = false;
      force = true;
    };
  };
}
