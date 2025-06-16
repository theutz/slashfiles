{
  osConfig,
  pkgs,
  lib,
  namespace,
  ...
}: {
  imports = [./karabiner ./spotify-player];

  slashfiles = lib.slashfiles.enableByPath [
    "bash"
    "bat"
    "btop"
    "direnv"
    "eza"
    "fish"
    "fzf"
    "ghostty"
    "git"
    "less"
    "mise"
    "nushell"
    "pkgs"
    "starship"
    "ssh"
    "tmux"
    "tmux.smart-splits"
    "wezterm"
    "xdg"
    "yazi"
    "zed"
    "zoxide"
    "zsh"
  ];

  home = {
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
    home-manager = {
      enable = true;
    };
  };
}
