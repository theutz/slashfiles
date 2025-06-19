{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (pkgs.${namespace}) dark-notify;
  exe = lib.getExe dark-notify;
in
  lib.slashfiles.mkModule {
    inherit config;
    here = ./.;
  } {
    config = {
      home.packages = [dark-notify];

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
          delta --"$(${exe} --exit | tr -d '\n')" --paging=never
        '';

      programs.tmux.extraConfig = ''
        set -ga terminal-overrides ",*-256color:Tc"
      '';
    };
  }
