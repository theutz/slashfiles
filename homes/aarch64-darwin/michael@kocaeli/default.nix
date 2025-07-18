{
  osConfig,
  pkgs,
  namespace,
  ...
}: {
  "${namespace}" = {
    aerospace.enable = true;
    bash.enable = true;
    bat.enable = true;
    btop.enable = true;
    chawan.enable = true;
    delta.enable = true;
    direnv.enable = true;
    eza.enable = true;
    fish.enable = true;
    fzf.enable = true;
    ghostty.enable = true;
    git.enable = true;
    glance.enable = true;
    karabiner.enable = true;
    less.enable = true;
    man.enable = true;
    mise.enable = true;
    nh.enable = true;
    noti.enable = true;
    nushell.enable = true;
    pkgs.enable = true;
    secrets.enable = true;
    spotify_player.enable = true;
    ssh.enable = true;
    starship.enable = true;
    starship.enableDarkNotifyIntegration = true;
    tealdeer.enable = true;
    tickrs.enable = true;
    tmux.enable = true;
    wezterm.enable = true;
    wthrr.enable = true;
    xdg.enable = true;
    yazi.enable = true;
    zed.enable = true;
    zk.enable = true;
    zoxide.enable = true;
    zsh.enable = true;
  };

  home = {
    sessionPath = [
      osConfig.homebrew.brewPrefix
    ];

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
