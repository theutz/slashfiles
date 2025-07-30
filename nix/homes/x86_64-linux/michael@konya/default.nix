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
      "eDP-1, preferred, auto, 1"
      "HDMI-A-1, preferred, auto-left, 1.25"
    ];
  };

  programs.wofi.enable = true;

  programs.zellij.enable = true;

  programs.tmux.enable = true;

  programs.home-manager.enable = true;

  programs.fzf.enable = true;

  programs.nh.enable = true;
  programs.nh.clean.enable = true;
  programs.nh.flake = "${config.home.homeDirectory}/${namespace}";
  home.shellAliases.nhs = "nh home switch";
  home.shellAliases.nos = "nh os switch";

  programs.nix-index.enable = true;

  home.stateVersion = "25.05";
}
