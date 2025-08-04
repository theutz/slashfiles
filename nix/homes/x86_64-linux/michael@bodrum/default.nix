{
  config,
  namespace,
  ...
}:
{
  imports = [
    ./git.nix
    ./secrets.nix
  ];

  ${namespace} = {
    base = {
      enable = true;
      enableWorkstation = true;
    };

    hyprland.monitor = [
      "DP-2, 2560x1440@59.95Hz, auto-left, auto"
      "eDP-1, preferred, auto, 1"
    ];
  };

  programs.wofi.enable = true;

  programs.zellij.enable = true;

  programs.tmux.enable = true;

  programs.home-manager.enable = true;

  programs.fzf.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    flake = "${config.home.homeDirectory}/${namespace}";
  };

  programs.nix-index.enable = true;

  services.ssh-agent.enable = true;

  home.shellAliases = {
    nhs = "nh home switch";
    nos = "nh os switch";
  };

  home.stateVersion = "25.05";
}
