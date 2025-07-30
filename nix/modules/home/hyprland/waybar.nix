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
          height = 48;
          modules-left = [
            "hyprland/workspaces"
            "hyprland/window"
          ];
          modules-center = [];
          modules-right = [];

          "hyprland/workspaces" = {
            all-outputs = true;
            format = ''{icon} {name}'';
            window-rewrite-default = ".";
            persistent-workspaces = {
              "*" = cfg.workspaces;
            };
            format-icons = {
              active = "";
              default = "";
              empty = "";
              persistent = "";
              special = "s";
              urgent = "u";
            };
          };

          "hyprland/window" = {
            icon = true;
          };
        };
      };

      style =
        # css
        ''
          .mainBar {
            background-color: transparent;
            font-family: ${lib.replaceString "Propo" "Mono" font.family};
            font-size: 16px;
            color: ${rp "text"};
          }

          #workspaces {
            margin: 1rem 1rem 0;
          }

          #workspaces button {
            border-radius: 0.75rem;
            background-color: alpha(${rp "surface"}, 0.9);
            color: ${rp "text"};
          }

          #workspaces button:not(:last-child) {
            margin-right: 0.5rem;
          }

          #workspaces button:hover {
            color: ${rp "base"};
            background: ${rp "gold"};
            border: none;
          }

          #workspaces button.active {
            color: ${rp "gold"};
          }

          window#waybar #window {
            background: alpha(${rp "surface"}, 0.9);
            padding: 0.5rem 1rem;
            margin-top: 1rem;
            border-radius: 0.75rem;
          }

          window#waybar #window.empty {
            background: transparent;
          }
        '';
    };
  };
}
