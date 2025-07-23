{
  pkgs,
  namespace,
  config,
  lib,
  ...
}: let
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  options.${namespace}.${mod} = {enable = lib.mkEnableOption "enable ${mod}";};
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kitty
    ];

    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
    };

    services.blueman = {
      enable = true;
    };
  };
}
