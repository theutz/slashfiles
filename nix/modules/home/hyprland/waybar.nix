{
  namespace,
  lib,
  config,
  ...
}: let
  cfg = config.${namespace}.${mod};
  mod = baseNameOf ./.;
  rp = lib.${namespace}.rose-pine.hex "main";
  inherit (lib.${namespace}) font;
in {
  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;

      settings = {
        mainBar = {
          name = "mainBar";
          layer = "top";
          position = "top";
          height = 30;
          modules-left = [
            "hyprland/workspaces"
          ];
          modules-center = [];
          modules-right = [];

          "hyprland/workspaces" = {
          };
        };
      };

      style =
        # css
        ''
          .mainBar {
            background-color: transparent;
            font-family: ${font.family};
            font-size: ${toString font.size}px;
          }
        '';
    };
  };
}
