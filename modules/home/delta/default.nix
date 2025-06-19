{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  inherit (pkgs.${namespace}) dark-notify;
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
        # ''delta "$(if dark-mode status | grep on; then echo "--dark"; else echo "--light"; fi)" --paging=never'';
        let
          exe = pkgs.${namespace}.dark-notify |> lib.getExe |> lib.trim;
        in ''
          mode=$(${exe} --exit); delta --"$mode" --paging-never
        '';

      programs.tmux.extraConfig = ''
        set -ga terminal-overrides ",*-256color:Tc"
      '';
    };
  }
