{pkgs, ...}: {
  slashfiles = {
    bash.enable = true;
    fish.enable = true;
    git.enable = true;
    nh.enable = true;
    pkgs.enable = true;
    ssh.enable = true;
    tmux.enable = true;
    wezterm.enable = true;
    xdg.enable = true;
    zsh.enable = true;
  };

  home.stateVersion = "25.05";
}
