{
  lib,
  cfg,
  ...
}: {
  inherit (cfg) monitor;

  xwayland = {
    force_zero_scaling = true;
  };

  "$terminal" = "uwsm app -- wezterm";
  "$fileManager" = "uwsm app -- dolphin";
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

  "$mainMod" = "SUPER";

  bind =
    (lib.concatLists (lib.genList (x: let
        num = toString (x + 1);
      in [
        "$mainMod, ${num}, workspace, ${num}"
        "$mainMod SHIFT, ${num}, movetoworkspace, ${num}"
      ])
      cfg.workspaces))
    ++ [
      "$mainMod, B, exec, $browser"
      "$mainMod, E, exec, $fileManager"
      "$mainMod, F, fullscreen, 1"
      "$mainMod, G, changegroupactive, f"
      "$mainMod SHIFT, G, togglegroup"
      "$mainMod SHIFT, F, fullscreen, 0"
      "$mainMod, H, movefocus, l"
      "$mainMod SHIFT, H, swapwindow, l"
      "$mainMod ALT, H, moveintogroup, l"
      "$mainMod, J, movefocus, d"
      "$mainMod SHIFT, J, swapwindow, d"
      "$mainMod ALT, J, moveintogroup, d"
      "$mainMod, K, movefocus, u"
      "$mainMod SHIFT, K, swapwindow, u"
      "$mainMod ALT, K, moveintogroup, u"
      "$mainMod, L, movefocus, r"
      "$mainMod SHIFT, L, swapwindow, r"
      "$mainMod ALT, L, moveintogroup, r"
      "$mainMod, M, exec, $terminal"
      "$mainMod, N, workspace, +1"
      "$mainMod SHIFT, N, movetoworkspace, +1"
      "$mainMod, P, workspace, -1"
      "$mainMod SHIFT, P, movetoworkspace, -1"
      "$mainMod, Q, killactive,"
      "$mainMod ALT CTRL, Q, exec, uwsm stop"
      "$mainMod, R, layoutmsg, movetoroot"
      "$mainMod, S, togglespecialworkspace, magic"
      "$mainMod SHIFT, S, movetoworkspace, special:magic"
      "$mainMod, V, layoutmsg, swapsplit"
      "$mainMod SHIFT, V, togglesplit, # dwindle"
      "$mainMod, Z, togglefloating,"

      "$mainMod ALT, H, movecurrentworkspacetomonitor, l"
      "$mainMod ALT, L, movecurrentworkspacetomonitor, r"

      "$mainMod, space, exec, $menu"
      "$mainMod, equal, splitratio, +0.1"
      "$mainMod, minus, splitratio, -0.1"
      "$mainMod, 0, splitratio, exact 1.0"

      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"
    ];

  bindm = [
    "$mainMod, mouse:272, movewindow"
    "$mainMod, mouse:273, resizewindow"
  ];

  windowrule = [
    "suppressevent maximize, class:.*"
    "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
  ];
}
