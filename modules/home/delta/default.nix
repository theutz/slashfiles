{
  lib,
  config,
  namespace,
  ...
}:
lib.slashfiles.mkModule {
  inherit config;
  here = ./.;
} {
  config = {
    programs.git.delta = {
      enable = config.${namespace}.git.enable;
      options = {
        dark =
          {
            rose-pine = true;
            rose-pine-moon = true;
            rose-pine-dawn = false;
          }
          |> lib.getAttr lib.${namespace}.prefs.theme.main;
      };
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
