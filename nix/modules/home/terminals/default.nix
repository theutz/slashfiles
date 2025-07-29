{
  config,
  pkgs,
  lib,
  namespace,
  ...
}: let
  inherit (builtins) baseNameOf;
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) theme font;

  color_scheme =
    ({
      rose-pine = "rose-pine";
      rose-pine-dawn = "rose-pine-dawn";
      rose-pine-moon = "rose-pine-moon";
    }).${
      theme.name
    };
in {
  options.${namespace}.${mod}.enable = mkEnableOption "enable ${mod}";

  config = mkIf cfg.enable {
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
          }
        '';
    };
  };
}
