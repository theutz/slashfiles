{
  lib,
  namespace,
  pkgs,
  config,
  ...
}: let
  inherit (lib.${namespace}.prefs.theme) main;

  variants = {
    rose-pine = {"@rose_pine_variant" = "main";};
    rose-pine-moon = {"@rose_pine_variant" = "moon";};
    rose-pine-dawn = {"@rose_pine_variant" = "dawn";};
  };

  mkVariantOpt = theme:
    variants
    |> lib.getAttr theme
    |> lib.foldlAttrs (_: n: v: "${n} '${v}'") null;

  theme-plugins = rec {
    rose-pine = pkgs.tmuxPlugins.rose-pine;
    rose-pine-dawn = rose-pine;
    rose-pine-moon = rose-pine;
  };

  settings = let
    rose-pine = ''
      set -goq ${(mkVariantOpt main)}
      set -g @rose_pine_host 'on'
      set -g @rose_pine_datetime '%Y-%m-%d'
      set -g @rose_pine_user 'on'
      set -g @rose_pine_directory 'on'
      set -g @rose_pine_status_left_prepend_section '#{tmux_mode_indicator}'
    '';
  in {
    inherit rose-pine;
    rose-pine-dawn = rose-pine;
    rose-pine-moon = rose-pine;
    catppuccin-mocha = ''
      set -g status-left-length 100
      set -g status-right-length 100
      set -g status-left ""
      set -g @catppuccin_flavor 'mocha'
      set -g @catppuccin_window_status_style "slanted"
      set -g status-right "#{E:@catppuccin_status_application}"
      set -ag status-right "#{E:@catppuccin_status_session}"
      set -ag status-right "#{E:@catppuccin_status_uptime}"
    '';
  };

  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  config = lib.mkIf cfg.enable {
    "${namespace}".${mod} = {
      tmuxConf.themes = config.lib.dag.entryBefore ["hmBoundary"] settings.${main};
    };

    programs.tmux = {
      plugins = [
        theme-plugins.${main}
      ];
    };
  };
}
