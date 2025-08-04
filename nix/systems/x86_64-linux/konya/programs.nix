{pkgs, ...}: {
  xdg.terminal-exec = {
    enable = true;
    settings.default = ["org.wezfurlong.wezterm.desktop"];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.firefox.enable = true;

  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  programs.tmux.enable = true;

  programs.zsh.enable = true;

  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.command-not-found.enable = false;

  programs._1password.enable = true;
  programs._1password-gui.enable = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    comma
    nh
    neovim
    yazi
  ];
}
