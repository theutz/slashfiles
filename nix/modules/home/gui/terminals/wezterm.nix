{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib.${namespace}.mkMod config ./.) mkConfig;
  inherit (lib.${namespace}) theme font;

  color_scheme =
    ({
      rose-pine = "rose-pine";
      rose-pine-dawn = "rose-pine-dawn";
      rose-pine-moon = "rose-pine-moon";
    }).${theme.name};
in
{
  config = mkConfig {
    home.packages = [
      (lib.getAttrFromPath font.pkg pkgs)
    ];

    programs.wezterm = {
      enable = true;

      extraConfig =
        # lua
        ''
          return {
            font = wezterm.font("${font.family}"),
            font_size = ${toString font.size}.0,

            color_scheme = "${color_scheme}",

            hide_tab_bar_if_only_one_tab = true,

            send_composed_key_when_left_alt_is_pressed = false,
            send_composed_key_when_right_alt_is_pressed = true,

            quick_select_patterns = {
              '^sha256-[0-9A-Za-z+]{40,50}=$',
            },

            default_prog = { "${lib.getExe pkgs.fish}" },

            debug_key_events = false, -- make `true` to log keys when launching from terminal
          }
        '';
    };
  };
}
