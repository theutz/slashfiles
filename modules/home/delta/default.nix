{
  lib,
  config,
  namespace,
  pkgs,
  ...
}:
lib.slashfiles.mkModule {
  inherit config;
  here = ./.;
} {
  config = {
    home.packages = with pkgs; [
      pkgs.${namespace}.dark-notify
    ];

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
        delta "--$(dark-notify status --exit)" --paging=never
      '';

    programs.tmux.extraConfig = ''
      set -ga terminal-overrides ",*-256color:Tc"
    '';
  };
}
