{pkgs, ...}: {
  imports = [
    ./kanata.nix
    ./hyprland.nix
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs = {
    firefox.enable = true;

    vim = {
      enable = true;
      defaultEditor = true;
    };

    tmux.enable = true;

    zsh.enable = true;

    nix-index = {
      enable = true;
      enableBashIntegration = true;
    };

    command-not-found.enable = false;

    _1password.enable = true;
    _1password-gui.enable = true;
  };

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
