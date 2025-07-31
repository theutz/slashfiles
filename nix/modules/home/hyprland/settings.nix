{
  config,
  lib,
  ...
}: let
  inherit (lib.slashfiles.mkMod config ./.) mkConfig cfg;
in {
  config = mkConfig {
    wayland.windowManager.hyprland.settings = {
      inherit (cfg) monitor;

      xwayland = {
        force_zero_scaling = true;
      };

      "$terminal" = "uwsm app -- wezterm";
      "$fileManager" = "uwsm app -- wezterm start yazi";
      "$menu" = "uwsm app -- wofi --show drun";
      "$browser" = "uwsm app -- qutebrowser";

      exec-once = [
        "$terminal"
        "waybar"
      ];

      env = [
        "GDK_SCALE,2"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 20;

        border_size = 2;

        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        resize_on_border = false;

        allow_tearing = false;

        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        rounding_power = 2;

        active_opacity = 0.95;
        inactive_opacity = 0.80;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      animations = {
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = false;
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;

        touchpad = {
          natural_scroll = true;
        };
      };

      gestures = {
        workspace_swipe = false;
      };

      bind =
        (lib.concatLists (lib.genList (x: let
            index = x + 1;
            num = toString (
              if index == 10
              then 0
              else (x + 1)
            );
          in [
            "SUPER, ${num}, workspace, ${toString index}"
            "SUPER SHIFT, ${num}, movetoworkspace, ${toString index}"
          ])
          cfg.workspaces))
        ++ [
          ", XF86MonBrightnessUp, exec, brightnessctl set +10%"
          ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioMute, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0%"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+"

          "SUPER, B, exec, $browser"
          "SUPER SHIFT, B, exec, ${config.xdg.desktopEntries.browser.actions.work.exec}"

          "SUPER, E, exec, $fileManager"

          "SUPER, F, fullscreen, 1"
          "SUPER SHIFT, F, fullscreen, 0"

          "SUPER, G, changegroupactive, f"
          "SUPER SHIFT, G, togglegroup"

          "SUPER, H, movefocus, l"
          "SUPER CTRL, H, movewindow, mon:l"
          "SUPER SHIFT, H, swapwindow, l"
          "SUPER ALT, H, moveintogroup, l"

          "SUPER, J, movefocus, d"
          "SUPER SHIFT, J, swapwindow, d"
          "SUPER SHIFT ALT, J, movewindow, d"
          "SUPER ALT, J, moveintogroup, d"

          "SUPER, K, movefocus, u"
          "SUPER SHIFT, K, swapwindow, u"
          "SUPER SHIFT ALT, K, movewindow, u"
          "SUPER ALT, K, moveintogroup, u"

          "SUPER, L, movefocus, r"
          "SUPER SHIFT, L, swapwindow, r"
          "SUPER SHIFT ALT, L, movewindow, r"
          "SUPER ALT, L, moveintogroup, r"
          "SUPER CTRL, L, movewindow, mon:r"

          "SUPER, M, exec, $terminal"

          "SUPER, N, workspace, +1"
          "SUPER SHIFT, N, movetoworkspace, +1"

          "SUPER, P, workspace, -1"
          "SUPER SHIFT, P, movetoworkspace, -1"

          "SUPER, Q, killactive,"
          "SUPER ALT CTRL, Q, exec, uwsm stop"

          "SUPER, R, layoutmsg, movetoroot"

          "SUPER, S, togglespecialworkspace, scratch"
          "SUPER SHIFT, S, movetoworkspace, special:scratch"

          "SUPER, V, layoutmsg, swapsplit"
          "SUPER SHIFT, V, togglesplit, # dwindle"

          "SUPER, Z, togglefloating,"

          "SUPER, space, exec, $menu"
          "SUPER, equal, splitratio, +0.1"
          "SUPER, minus, splitratio, -0.1"
          "SUPER, 0, splitratio, exact 1.0"

          "SUPER, mouse_down, workspace, e+1"
          "SUPER, mouse_up, workspace, e-1"
        ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      windowrule = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];

      workspace = [
        "1,  monitor:DP-2"
        "2,  monitor:DP-2"
        "3,  monitor:DP-2"
        "4,  monitor:DP-2"
        "5,  monitor:DP-2"
        "6,  monitor:DP-2"
        "7,  monitor:eDP-1"
        "8,  monitor:eDP-1"
        "9,  monitor:eDP-1"
        "10, monitor:eDP-1"
      ];
    };
  };
}
