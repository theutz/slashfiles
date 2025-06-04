args @ {
  osConfig,
  pkgs,
  lib,
  namespace,
  ...
}: {
  imports = [./karabiner ./spotify-player];

  slashfiles = {
    packages.enable = true;
    git.enable = true;
    tmux.enable = true;
    yazi.enable = true;
  };

  home = {
    preferXdgDirectories = builtins.trace "trace: ${lib.attrNames args.osConfig or {}}" true;

    sessionPath = [
      osConfig.homebrew.brewPrefix
    ];

    sessionVariables = {
      DIRENV_LOG_FORMAT = ""; # Quiet!
      MANPAGER = "${lib.getExe pkgs.${namespace}.nvf} -c +Man!";
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
      functions = {
        fish_greeting = '''';
        fish_user_key_bindings = ''
          fish_default_key_bindings -M insert
          fish_vi_key_bindings --no-erase insert
        '';
      };
      shellInit =
        # fish
        ''
          fish_user_key_bindings
        '';
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
        font-family = "RobotoMono Nerd Font Propo";
        font-size = 16;
        font-thicken = true;
        # keybind = global:shift+f13=toggle_quick_terminal
        macos-option-as-alt = "left";
        macos-titlebar-style = "transparent";
        theme = "dracula";
        window-padding-balance = true;
        window-padding-x = 8;
        window-padding-y = 2;
        window-title-font-family = "RobotoMono Nerd Font Propo";
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
          config.color_scheme = "rose-pine"
          config.default_prog = { "${lib.getExe pkgs.fish}" }
          config.hide_tab_bar_if_only_one_tab = true

          -- For compatibility with mprocs https://github.com/pvolok/mprocs/issues/165
          -- config.enable_csi_u_key_encoding = true
          return config
        '';
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
