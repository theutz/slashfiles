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
      theme = pkgs.tmuxPlugins.dracula;

      plugins =
        lib.concat
        (lib.singleton theme)
        (with pkgs.tmuxPlugins; [
          sessionist
          pain-control
        ]);

      hasCatppuccin = lib.elem pkgs.tmuxPlugins.catppuccin plugins;
    in {
      inherit plugins;
      aggressiveResize = true;
      baseIndex = 1;
      clock24 = true;
      enable = true;
      escapeTime = 0;
      extraConfig = let
        killMenu = ''
          bind-key -N "Open kill menu" x \
            menu -T "Kill..." -x "#{popup_pane_left}" -y "#{popup_pane_bottom}" \
              server S {
                kill-server
              } \'\' session s {
                kill-session
              } other-sessions C-s {
                kill-session -a
              } 'bells' b {
                kill-session -C
              } \'\' window w {
                kill-window
              } other-windows C-w {
                kill-window -a
              } respawn-window W {
                respawn-window -k
              } \'\' pane p {
                kill-pane
              } other-panes C-p {
                kill-pane -a
              } respawn-pane P {
                respawn-pane -k
              }
        '';
        menus = lib.concatLines [
          killMenu
        ];
      in
        # tmux
        ''
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

          ${menus}
        '';
      focusEvents = true;
      keyMode = "vi";
      mouse = true;
      prefix = "M-m";
      tmuxp.enable = true;
    };
  };
}
