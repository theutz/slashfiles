{
  lib,
  namespace,
  config,
  pkgs,
  ...
}:
lib.${namespace}.mkModule {
  inherit config;
  here = ./.;
} {
  imports = [
    ./menus.nix
    ./aliases.nix
    ./smart-splits.nix
  ];

  config = let
    inherit (pkgs.tmuxPlugins) rose-pine catppuccin;

    plugins = with pkgs.tmuxPlugins; [
      sessionist
      pain-control
      rose-pine
      mode-indicator
    ];

    hasPlugin = (lib.flip lib.elem) plugins;

    catppuccinSettings = ''
      set -g status-left-length 100
      set -g status-right-length 100
      set -g status-left ""
      set -g @catppuccin_flavor 'mocha'
      set -g @catppuccin_window_status_style "slanted"
      set -g status-right "#{E:@catppuccin_status_application}"
      set -ag status-right "#{E:@catppuccin_status_session}"
      set -ag status-right "#{E:@catppuccin_status_uptime}"
    '';

    rosePineSettings = ''
      set -g @rose_pine_variant "main"
      set -g @rose_pine_host 'on'
      set -g @rose_pine_datetime '%Y-%m-%d'
      set -g @rose_pine_user 'on'
      set -g @rose_pine_directory 'on'
      set -g @rose_pine_status_left_prepend_section '#{tmux_mode_indicator}'
    '';
  in {
    xdg.configFile."tmux/tmux.conf".text = lib.mkBefore ''
      ${lib.optionalString (hasPlugin catppuccin) catppuccinSettings}
      ${lib.optionalString (hasPlugin rose-pine) rosePineSettings}
    '';

    home.activation.reloadTmux = let
      tmux = lib.getExe pkgs.tmux;
      file = lib.concatStringsSep "/" [config.xdg.configHome "tmux" "tmux.conf"];
    in
      config.lib.dag.entryAfter ["writeBoundary"]
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
      inherit plugins;

      aggressiveResize = true;
      baseIndex = 1;
      clock24 = true;
      enable = true;
      escapeTime = 0;
      extraConfig = ''
        set -g allow-passthrough all
        set -g allow-rename on
        set -g default-command "${lib.getExe pkgs.fish}"
        set -g default-terminal "xterm-256color"
        set -g extended-keys always
        set -g terminal-overrides ",xterm*:Tc"
        set -g renumber-windows on

        set -sa terminal-features "xterm*:extkeys"
        set -ga update-environment TERM
        set -ga update-environment TERM_PROGRAM
        set -ga update-environment PATH
        set -ga update-environment EDITOR
        set -ga update-environment VISUAL

        set-hook -g pane-died[10] {
            display-menu -T "What next?" -x "#{popup_pane_right}" -y "#{popup_pane_bottom}" \
              "respawn pane" r { \
                respawn-pane -k \
              } "new command" n {
                command-prompt -I 'respawn-pane #{pane_start_command}'
              } "kill-pane" q {
                kill-pane  \
              } "scroll up" C-u {
                copy-mode
                send-keys -X halfpage-up
              }
          }

        bind-key -n -N "Respawn dead pane" Enter \
          if -F '#{pane_dead}' respawn-pane { send-keys Enter }
        bind-key -n -N "Kill dead pane" q \
          if -F '#{pane_dead}' kill-pane { send-keys q }
        bind-key -n -N "Open command prompt" : \
          if -F '#{pane_dead}' command-prompt { send-keys : }

        bind-key -N "Copy mode" C-u "copy-mode; send-keys -X halfpage-up"
        bind-key -N "Session picker" s choose-tree -sZ -O time
        bind-key -N "Rename pane" M-, command-prompt -I "#T" { select-pane -T "%%" }
        bind-key -N "Customize mode" O customize-mode -Z
        bind-key -N "Last session" S switch-client -l
        bind-key -N "Last window" \; last-window
        bind-key -N "Last pane" M-\; last-pane -Z
        bind-key -N "List all keys" / list-keys
        bind-key -N "Clear screen" C-h send 'C-h'
        bind-key -N "Clear screen" C-j send 'C-j'
        bind-key -N "Clear screen" C-k send 'C-k'
        bind-key -N "Clear screen" C-l send 'C-l'
        set-option -s user-keys[0] "\e[13;2u"
        bind-key -n User0 send-keys "\e[13;2u"
      '';
      focusEvents = true;
      keyMode = "vi";
      mouse = true;
      prefix = "M-m";
      tmuxp.enable = true;
    };
  };
}
