{
  lib,
  config,
  namespace,
  ...
}: let
  themes = rec {
    rose-pine = "ansi";
    rose-pine-moon = rose-pine;
    rose-pine-dawn = rose-pine;
  };
  inherit (lib.${namespace}.prefs.theme) main;
  theme = lib.getAttrs main themes;
in
  lib.slashfiles.mkModule {
    inherit config;
    here = ./.;
  } {
    config = {
      programs.git.delta = {
        enable = config.${namespace}.git.enable;
        options = {};
      };

      programs.lazygit.settings.git.paging.pager =
        # bash
        ''
          delta "$(dark-mode status | grep on && echo "--dark" || echo "--light")" --paging=never
        '';

      programs.tmux.extraConfig = ''
        set -ga terminal-overrides ",*-256color:Tc"
      '';
    };
  }
