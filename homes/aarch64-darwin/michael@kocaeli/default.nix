{
  osConfig,
  pkgs,
  lib,
  namespace,
  ...
}: {
  imports = [./karabiner ./spotify-player];

  slashfiles = lib.slashfiles.enableByPath [
    "bat"
    "btop"
    "direnv"
    "fish"
    "fzf"
    "ghostty"
    "git"
    "less"
    "mise"
    "pkgs"
    "starship"
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

    zsh = {
      enable = true;
    };
  };

  xdg = {
    enable = true;
  };
}
