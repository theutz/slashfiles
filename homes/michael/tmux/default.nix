{
  lib,
  pkgs,
  config,
  ...
}: {
  config = {
    home.activation.reloadTmux = let
      tmux = lib.getExe pkgs.tmux;
      file = lib.concatStringsSep "/" [config.xdg.configHome "tmux" "tmux.conf"];
    in
      lib.hm.dag.entryAfter ["writeBoundary"]
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

    programs.tmux = let
      inherit (pkgs.tmuxPlugins) rose-pine catppuccin;

      plugins = with pkgs.tmuxPlugins; [
        sessionist
        pain-control
        rose-pine
      ];

      hasCatppuccin = lib.elem catppuccin plugins;
      hasRosePine = lib.elem rose-pine plugins;
    in {
      inherit plugins;

      aggressiveResize = true;
      baseIndex = 1;
      clock24 = true;
      enable = true;
      escapeTime = 0;
      extraConfig = ''
        set -g allow-passthrough on
        set -g allow-rename on
        set -g default-command "${lib.getExe pkgs.fish}"
        set -g default-terminal "xterm-256color"
        set -g extended-keys always
        set -g terminal-overrides ",xterm*:Tc"
        set -sa terminal-features "xterm*:extkeys"
        set -ga update-environment TERM
        set -ga update-environment TERM_PROGRAM
        set -ga update-environment PATH
        set -ga update-environment EDITOR
        set -ga update-environment VISUAL

        ${lib.optionalString hasCatppuccin ''
          set -g status-left-length 100
          set -g status-right-length 100
          set -g status-left ""
          set -g @catppuccin_flavor 'mocha'
          set -g @catppuccin_window_status_style "slanted"
          set -g status-right "#{E:@catppuccin_status_application}"
          set -ag status-right "#{E:@catppuccin_status_session}"
          set -ag status-right "#{E:@catppuccin_status_uptime}"
        ''}

        ${lib.optionalString hasRosePine ''
          set -g @rose_pine_variant "main"
        ''}

      '';
      focusEvents = true;
      keyMode = "vi";
      mouse = true;
      prefix = "M-m";
      tmuxp.enable = true;
    };
  };
}
