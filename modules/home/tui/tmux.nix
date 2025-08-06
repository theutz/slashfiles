{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkConfig;
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

        bind-key S 'switch-client -l'
      ''
      + (lib.${namespace}.tmux.mkCommandAliases {
        btop = "popup -EE -h90% -w95% -xC -yC -b heavy 'btop'";
        exit-node = "popup -h100% -w50% -xC -yC 'exit-node'";
        h = "split-window -v";
        man = "split-window -h -f -l 80 man";
        pause = "send -t spotify:main.1 ' '";
        play = "send -t spotify:main.1 ' '";
        reload = "source $HOME/.config/tmux/tmux.conf";
        restore = ''run-shell $HOME/.config/tmux/plugins/tmux-resurrect/scripts/restore.sh'';
        rp = "select-pane -T";
        rs = "rename-session";
        rw = "rename-window";
        s = "new-session";
        save = ''run-shell $HOME/.config/tmux/plugins/tmux-resurrect/scripts/save.sh'';
        sp = ''respawn-pane'';
        spk = ''respawn-pane -k'';
        spotify = "popup -EE -h80% -w90% -xC -yC -b heavy spotify_player";
        spw = ''respwan-window'';
        spwk = ''respwan-window -k'';
        tz = ''popup -EE -xC -yC -b rounded -w100 -h20 -s "bg=colour8" tz'';
        v = "split-window -h";
        vol = "popup -xC -yS -w100 -h5 -b rounded -EE volgo";
        w = "new-window";
        x = "resize-pane -x";
        y = "resize-pane -y";
      });
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
