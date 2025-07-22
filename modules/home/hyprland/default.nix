{
  config,
  pkgs,
  lib,
  namespace,
  ...
}: let
  mod = builtins.baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  options.${namespace}.${mod}.enable = lib.mkEnableOption "enable ${mod}";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      wofi
      kitty
      kdePackages.dolphin
      dunst
      pipewire
      wireplumber
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        monitor = [", preferred, auto, auto"];
        "$terminal" = "wezterm";
        "$fileManager" = "dolphin";
        "$menu" = "wofi --show drun";

        exec-once = [
          "$terminal"
        ];
        env = [
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

        "$mainMod" = "SUPER";

        bind = [
          "$mainMod, M, exec, $terminal"
          "$mainMod, C, killactive,"
          "$mainMod, Q, exit,"
          "$mainMod, E, exec, $fileManager"
          "$mainMod, Z, togglefloating,"
          "$mainMod, R, exec, $menu"
          "$mainMod, P, pseudo, # dwindle"
          "$mainMod, V, togglesplit, # dwindle"

          "$mainMod, H, movefocus, l"
          "$mainMod, L, movefocus, r"
          "$mainMod, K, movefocus, u"
          "$mainMod, J, movefocus, d"

          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"
        ];

        windowrule = [
          "suppressevent maximize, class:.*"
          "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        ];
      };
    };
  };
}
