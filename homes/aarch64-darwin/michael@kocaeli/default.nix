args @ {
  osConfig,
  pkgs,
  lib,
  namespace,
  ...
}: {
  imports = [./karabiner ./spotify-player];

  slashfiles = lib.slashfiles.enableByPath [
    "fish"
    "fzf"
    "ghostty"
    "git"
    "less"
    "mise"
    "monitoring"
    "pkgs"
    "ssh"
    "tmux"
    "tmux.smart-splits"
    "wezterm"
    "yazi"
    "zed"
    "zoxide"
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

    zsh = {
      enable = true;
    };
  };

  xdg = {
    enable = true;
  };
}
