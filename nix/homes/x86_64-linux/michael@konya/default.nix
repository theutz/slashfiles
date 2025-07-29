{config, pkgs, namespace, ...}: {
  imports = [
    ./git.nix
  ];

  ${namespace} = {
    lazyvim.enable = true;
    hypr.enable = true;
    qutebrowser.enable = true;
  };

  programs.wofi.enable = true;

  programs.zellij.enable = true;

  programs.zsh.enable = true;

  programs.bash.enable = true;

  programs.fish.enable = true;

  programs.nushell.enable = true;

  programs.tmux.enable = true;

  programs.home-manager.enable = true;

  programs.nh.enable = true;
  programs.nh.clean.enable = true;
  programs.nh.flake = "${config.home.homeDirectory}/${namespace}";
  home.shellAliases.nhs = "nh home switch";
  home.shellAliases.nos = "nh os switch";

  programs.nix-index.enable = true;

  home.stateVersion = "25.05";
}
