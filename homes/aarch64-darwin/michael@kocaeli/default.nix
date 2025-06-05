args @ {
  osConfig,
  pkgs,
  lib,
  namespace,
  ...
}: {
  imports = [./karabiner ./spotify-player];

  slashfiles = lib.slashfiles.enableByPath [
    "fzf"
    "ghostty"
    "git"
    "packages"
    "tmux"
    "tmux.smart-splits"
    "yazi"
    "wezterm"
  ];

  home = {
    preferXdgDirectories = true;

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

    home-manager = {
      enable = true;
    };

    nushell = {
      enable = true;
    };

    starship = {
      enable = true;
      settings =
        (builtins.fetchGit {
          url = "https://github.com/rose-pine/starship";
          rev = "c6aeb2833e3d563ca3bbffcb4bad09d44bf817ec";
        })
        |> lib.getAttr "outPath"
        |> (p: "${p}/rose-pine.toml")
        |> lib.fileContents
        |> builtins.fromTOML;
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
