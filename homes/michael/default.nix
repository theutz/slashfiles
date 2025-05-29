{
  osConfig,
  config,
  pkgs,
  lib,
  packages,
  ...
}: {
  home = {
    activation = {
      reloadTmux = let
        tmux = lib.getExe pkgs.tmux;
        file = lib.concatStringsSep "/" [config.xdg.configHome "tmux" "tmux.conf"];
      in
        lib.hm.dag.entryAfter ["writeBoundary"]
        /*
        bash
        */
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
    };
    packages =
      [
        packages.home
        packages.swch
        packages.nvf
      ]
      ++ (with pkgs; [
        zoom-us
        coreutils
        delta
        fd
        lazygit
        procs
        ripgrep
        aichat
        signal-desktop-bin
      ]);
    preferXdgDirectories = true;
    sessionPath = [
      osConfig.homebrew.brewPrefix
    ];
    sessionVariables = {
      DIRENV_LOG_FORMAT = ""; # Quiet!
      MANPAGER = "${lib.getExe packages.nvf} -c +Man!";
      MANWIDTH = 999;
    };
    shell = {
      # Enables in all shells
      enableShellIntegration = true;
    };
    shellAliases = {
      lg = "lazygit";
    };
    stateVersion = "25.05";
  };
  programs = {
    lazygit = {
      enable = true;
      settings = {
        customCommands = [
          {
            key = "b";
            context = "files";
            command = "HK_PROFILE=ai git commit";
            description = "generate commit message with llm";
            output = "terminal";
          }
        ];
        disableStartupPopups = true;
        git = {
          commit = {
            signoff = true;
          };
          paging = {
            colorArg = "always";
            pager = ''
              delta "$(dark-mode status | grep on && echo "--dark" || echo "--light")" --paging=never
            '';
            parseEmoji = true;
            overrideGpg = true;
          };
        };
        gui = {
          border = "rounded";
          expandFocusedSidePanel = true;
          nerdFontsVersion = "3";
          showBottomLine = false;
          showCommandLog = true;
          showRandomTip = false;
        };
        notARepository = "skip";
        promptToReturnFromSubprocess = false;
      };
    };

    bat = {
      enable = true;
      config = {theme = "Dracula";};
    };
    bash = {
      enable = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    eza = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };
    fish = {
      enable = true;
    };
    gh = {
      enable = true;
    };
    ghostty = {
      enable = true;
      package =
        if pkgs.stdenv.hostPlatform.isDarwin
        then null
        else pkgs.ghostty;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };
    git = {
      delta = {
        enable = true;
      };
    };
    home-manager = {
      enable = true;
    };
    nushell = {
      enable = true;
    };
    starship = {
      enable = true;
    };
    tmux = {
      aggressiveResize = true;
      baseIndex = 1;
      clock24 = true;
      # customPaneNavigationAndResize = true;
      enable = true;
      escapeTime = 0;
      extraConfig =
        /*
        tmux
        */
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
        '';
      focusEvents = true;
      keyMode = "vi";
      mouse = true;
      plugins = with pkgs; [
        tmuxPlugins.sessionist
        tmuxPlugins.pain-control
        tmuxPlugins.dracula
      ];
      prefix = "M-m";
    };
    wezterm = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      extraConfig = let
        fish = lib.getExe pkgs.fish;
      in
        /*
        lua
        */
        ''
          local config = wezterm.config_builder()

          config.font_size = 16
          config.color_scheme = "Dracula"
          config.default_prog = { "${fish}" }
          -- For compatibility with mprocs https://github.com/pvolok/mprocs/issues/165
          -- config.enable_csi_u_key_encoding = true
          return config
        '';
    };
    yazi = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };
    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };
    zsh = {
      enable = true;
    };
  };
  xdg = {
    enable = true;
    configFile = {
      "ghostty/config".source = ./ghostty-config;
      "karabiner/karabiner.json".source = ./karabiner.json;
    };
  };
}
