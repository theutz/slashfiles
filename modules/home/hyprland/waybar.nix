{
  namespace,
  lib,
  config,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkConfig;
  rp = lib.${namespace}.rose-pine.hex "main";
  inherit (lib.${namespace}) font;
in
{
  config = mkConfig {
    programs.waybar.enable = true;
    programs.waybar.systemd.enable = true;
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
            "class<1Password>" = "󰢁";
            "class<signal>" = "󰭹";
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
          format = " {:%H:%M %Z  %Od}";
          tooltip-format =
            # html
            ''
              <tt>
                <small>{tz_list}</small>
                <small>{calendar}</small>
              </tt>
            '';
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
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "wezterm start wiremix -v output";
          on-click-right = "wezterm start wiremix -v playback";
          reverse-scrolling = true;
          reverse-mouse-scrolling = true;
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

    xdg.desktopEntries.nerdfont-icons = {
      name = "NerdFont Icons";
      exec = "qutebrowser https://nerdfonts.ytyng.com";
    };

    programs.waybar.style =
      # css
      ''
        window.mainBar {
          background-color: transparent;
          font-family: ${font.family};
          font-size: 13px;
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
