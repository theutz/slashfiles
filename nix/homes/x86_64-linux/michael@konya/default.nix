{
  config,
  pkgs,
  namespace,
  ...
}: {
  imports = [
    ./git.nix
  ];

  ${namespace} = {
    base = {
      enable = true;
      enableWorkstation = true;
    };

    hyprland.monitor = [
      "eDP-1, preferred, auto, 1.25"
      "HDMI-A-1, preferred, auto-left, 1.25"
    ];
  };

  programs = {
    wofi.enable = true;

    zellij.enable = true;

    tmux.enable = true;

    home-manager.enable = true;

    fzf.enable = true;

    nh = {
      enable = true;
      clean.enable = true;
      flake = "${config.home.homeDirectory}/${namespace}";
    };

    nix-index.enable = true;
  };

  home.shellAliases = {
    nhs = "nh home switch";
    nos = "nh os switch";
  };

  home.stateVersion = "25.05";
}
