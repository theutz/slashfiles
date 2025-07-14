{
  lib,
  config,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) prefs;
  inherit (prefs) font;

  themes = {
    rose-pine = "Rosé Pine (Gogh)";
    rose-pine-dawn = "Rosé Pine Dawn (Gogh)"; # light
    rose-pine-moon = "Rosé Pine Moon (Gogh)";
    kanagawa = "Kanagawa (Gogh)";
    kanagawa-dragon = "Kanagawa Dragon (Gogh)";
    kanagawa-lotus = "Kanagawa (Gogh)"; # light
    flexoki-light = "flexoki-light";
    flexoki-dark = "flexoki-dark";
  };

  dark = lib.attrByPath [prefs.theme.dark] themes.rose-pine themes;
  light = lib.attrByPath [prefs.theme.light] dark themes;

  mod = builtins.baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  options.${namespace}.${mod}.enable = lib.mkEnableOption "enable ${mod}";

  config = lib.mkIf cfg.enable {
    xdg.configFile."wezterm/wezterm.lua" = {
      source =
        {
          fish = lib.getExe pkgs.fish;
          font-family = font.family;
          font-size = font.size;
          line-height = font.height;
          dark-theme = dark;
          light-theme = light;
          opacity = 0.85;
        }
        |> pkgs.replaceVars ./wezterm.lua;
      force = true;
    };
    programs.wezterm = {
      enable = true;

      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
