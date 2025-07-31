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
    programs.waybar.enable = true;

    programs.waybar.settings = {
      mainBar = {
        name = "mainBar";
        layer = "top";
        position = "top";
        height = 48;
        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [
          "hyprland/window"
        ];
        modules-right = [
          "network"
          "pulseaudio"
          "clock"
        ];

        "hyprland/workspaces" = {
          format = ''{icon} {name} {windows}'';
          show-special = true;
          window-rewrite-default = "";
          window-rewrite = {
            "class<org.qutebrowser.qutebrowser>" = "󰾔";
            "class<org.wezfurlong.wezterm>" = "";
            "class<Slack>" = "";
            "class<spotify>" = "";
          };
          format-icons = {
            active = "";
            default = "";
            empty = "";
            persistent = "󰺕";
            special = "󰘻";
            urgent = "󰵚";
          };
        };

        "hyprland/window" = {
          icon = true;
        };

        clock = {
          format = " {:%H:%M %Z}";
          tooltip-format = "{tz_list}";
          timezones = [
            "Europe/Istanbul"
            "America/New_York"
            "America/Los_Angeles"
            "Etc/UTC"
          ];
          actions = {
            on-click = "tz_down";
          };
        };

        pulseaudio = {
          format = "{icon} {volume}% {format_source}";
          format-bluetooth = "{icon} {volume}% {format_source}";
          format-bluetooth-muted = "{icon} {format_source}";
          format-muted = " {format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "󰏳";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "wezterm start wiremix";
        };

        network = {
          format-wifi = " {essid} ({signalStrength}%)";
          format-ethernet = "󰈀 {ipaddr}/{cidr}";
          tooltip-format = " {ifname} via {gwaddr}";
          format-linked = " {ifname} (No IP)";
          format-disconnected = "⚠ Disconnected";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
      };
    };

    programs.waybar.style =
      # css
      ''
        window.mainBar {
          background-color: transparent;
          font-family: ${font.family};
          font-size: 16px;
          color: ${rp "text"};
        }

        widget {
          color: ${rp "text"};
        }

        widget:not(:last-child) {
          padding-right: 1rem;
        }

        widget button {
          color: ${rp "text"};
        }

        #workspaces button:hover {
          color: ${rp "base"};
          background: ${rp "gold"};
          border: none;
        }

        #workspaces button.active {
          color: ${rp "gold"};
        }

        .modules-left, .modules-right, .modules-center {
          background: ${rp "surface"};
          border-radius: 0.75rem;
        }

        .modules-center, .modules-right {
          padding: 0 1rem;
        }

        .modules-left {
          margin-left: 1rem;
        }

        .modules-right {
          margin-right: 1rem;
        }

        .modules-right :not(:first-child) label {
          padding-left: 1.5rem;
        }

        window#waybar #window.empty {
          background: transparent;
        }
      '';
  };
}
