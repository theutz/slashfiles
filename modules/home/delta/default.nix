{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  options.${namespace}.${mod} = {
    enable = lib.mkEnableOption "enable ${mod}";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [dark-notify];

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
      ''delta "$(if dark-mode status | grep on; then echo "--dark"; else echo "--light"; fi)" --paging=never'';

    programs.tmux.extraConfig = ''
      set -ga terminal-overrides ",*-256color:Tc"
    '';
  };
}
