{
  osConfig,
  pkgs,
  lib,
  packages,
  ...
}: {
  imports = lib.pipe ./. [
    lib.filesystem.listFilesRecursive
    (lib.filter (f: f != /. + __curPos.file && (lib.hasSuffix "nix" f)))
  ];

  home = {
    packages =
      [
        packages.home
        packages.swch
        packages.nvf
      ]
      ++ (with pkgs;
        [
          zoom-us
          coreutils
          delta
          fd
          lazygit
          procs
          ripgrep
          aichat
          signal-desktop-bin
        ]
        ++ (with nerd-fonts; [
          roboto-mono
          blex-mono
        ]));
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
      settings = {
        adjust-cell-height = 16;
        background-opacity = 0.75;
        font-family = "Berkeley Mono";
        font-size = 16;
        font-thicken = true;
        # keybind = global:shift+f13=toggle_quick_terminal
        macos-option-as-alt = "left";
        macos-titlebar-style = "transparent";
        theme = "dracula";
        window-padding-balance = true;
        window-padding-x = 8;
        window-padding-y = 2;
        window-title-font-family = "Berkeley Mono";
      };
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
    wezterm = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      extraConfig =
        # lua
        ''
          local config = wezterm.config_builder()

          config.font = wezterm.font "RobotoMono Nerd Font Propo"
          config.font_size = 16
          config.line_height = 1.1
          config.color_scheme = "catppuccin-mocha"
          config.default_prog = { fish }
          config.hide_tab_bar_if_only_one_tab = false

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
  };
}
