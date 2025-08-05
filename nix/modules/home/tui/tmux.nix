{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.mkMod config ./.) mkConfig;
in
{
  config = mkConfig {
    home.activation.reloadTmux =
      let
        tmux = lib.getExe pkgs.tmux;
        file = lib.concatStringsSep "/" [
          config.xdg.configHome
          "tmux"
          "tmux.conf"
        ];
      in
      config.lib.dag.entryAfter [ "writeBoundary" ]
        # bash
        ''
          export TERM="xterm-256color"

          if
            run ${tmux} ls &>/dev/null
          then
            verboseEcho "Reloading tmux..."
            if
              run ${tmux} source-file "${file}"
            then
              verboseEcho "Tmux config reloaded!"
            else
              echo "ERROR: Could not reload tmux config."
            fi
          else
            verboseEcho "No tmux running"
          fi
        '';

    programs.tmux = {
      enable = true;
      aggressiveResize = true;
      baseIndex = 1;
      clock24 = true;
      customPaneNavigationAndResize = true;
      disableConfirmationPrompt = true;
      escapeTime = 10;
      extraConfig = ''
        set -g default-command ${lib.getExe pkgs.fish}
        set -g command-alias[100] x='resize-pane -x'
        set -g command-alias[101] y='resize-pane -y'

        bind-key S 'switch-client -l'
      '';
      focusEvents = true;
      historyLimit = 100000;
      keyMode = "vi";
      mouse = true;
      newSession = false;
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = rose-pine;
          extraConfig = ''
            set -g @rose_pine_variant 'main'
          '';
        }
        {
          plugin = resurrect;
          extraConfig = ''
            set -g @resurrect-strategy-nvim 'session'
          '';
        }
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '5' # minutes
          '';
        }
        pain-control
      ];
      prefix = "M-m";
      reverseSplit = false;
      sensibleOnTop = true;
      terminal = "xterm-256color";
      tmuxp = {
        enable = true;
      };
    };
  };
}
