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
    enableDarkNotifyIntegration = lib.mkEnableOption "update dark-mode with system appearance";
  };

  config = lib.mkIf cfg.enable (lib.recursiveUpdate {
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

      programs.tmux.extraConfig = ''
        set -ga terminal-overrides ",*-256color:Tc"
      '';
    } (lib.mkIf cfg.enableDarkNotifyIntegration {
      assertions = [
        {
          assertion = pkgs.stdenv.isDarwin;
          message = "Dark Notify integration is only available on darwin platforms.";
        }
      ];
      home.packages = with pkgs; [dark-notify];

      programs.lazygit.settings.git.paging.pager =
        # bash
        ''delta "$(if dark-mode status | grep on; then echo "--dark"; else echo "--light"; fi)" --paging=never'';
    }));
}
