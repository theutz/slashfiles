{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.mkMod config ./.) mkConfig cfg;
in
{
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
        new_window_takes_over_fullscreen = 1; # 0 - behind, 1 - takes over
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
        (lib.concatLists (
          lib.genList (
            x:
            let
              index = x + 1;
              num = toString (if index == 10 then 0 else (x + 1));
            in
            [
              "SUPER, ${num}, workspace, ${toString index}"
              "SUPER SHIFT, ${num}, movetoworkspace, ${toString index}"
            ]
          ) cfg.workspaces
        ))
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

          "SUPER, F, setfloating"
          "SUPER, F, resizeactive, exact 80% 80%"
          "SUPER, F, centerwindow, 1"

          "SUPER, G, changegroupactive, f"
          "SUPER SHIFT, G, changegroupactive, b"
          "SUPER CTRL, G, togglegroup"

          "SUPER, H, movefocus, l"
          "SUPER SHIFT, H, swapwindow, l"
          "SUPER CTRL, H, movewindoworgroup, l"
          "SUPER ALT, H, movewindow, l"

          "SUPER, J, movefocus, d"
          "SUPER SHIFT, J, swapwindow, d"
          "SUPER CTRL, J, movewindoworgroup, d"
          "SUPER ALT, J, movewindow, d"

          "SUPER, K, movefocus, u"
          "SUPER SHIFT, K, swapwindow, u"
          "SUPER CTRL, K, movewindoworgroup, u"
          "SUPER ALT, K, movewindow, u"

          "SUPER, L, movefocus, r"
          "SUPER SHIFT, L, swapwindow, r"
          "SUPER CTRL, L, movewindoworgroup, r"
          "SUPER ALT, L, movewindow, r"

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

          "SUPER, T, settiled"
          "SUPER, T, splitratio, exact 1.0"

          "SUPER, V, togglesplit, # dwindle"
          "SUPER SHIFT, V, layoutmsg, swapsplit"

          "SUPER, Z, fullscreen, 1"
          "SUPER SHIFT, Z, fullscreen, 0"

          "SUPER, space, exec, $menu"
          "SUPER ALT, space, centerwindow, 1"

          "SUPER, equal, splitratio, exact 1.0"
          "SUPER SHIFT, equal, splitratio, +0.1"
          "SUPER ALT, equal, resizeactive, 10% 10%"

          "SUPER, minus, splitratio, -0.1"
          "SUPER ALT, minus, resizeactive, -10% -10%"

          "SUPER, tab, workspace, e+1"
          "SUPER SHIFT, tab, workspace, e-1"

          "SUPER, mouse_down, workspace, e+1"
          "SUPER, mouse_up, workspace, e-1"

          "Alt_R, slash, exec, playerctl play-pause"
          "Alt_R, period, exec, playerctl next"
          "Alt_R, comma, exec, playerctl previous"
        ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      bindl = [
        ",switch:on:Lid Switch, exec, hyprlock --immediate"
        ",switch:off:Lid Switch, exec, hyprlock --immediate"
        ",switch:on:Lid Switch, exec, playerctl pause"
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
