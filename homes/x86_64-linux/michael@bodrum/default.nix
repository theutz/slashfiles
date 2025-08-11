{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib.${namespace}) genEnabledMods;
in
{
  ${namespace} = lib.mkMerge [
    (genEnabledMods (import ./mods.nix))
    {
      hyprland.monitor = [
        "DP-2, 2560x1440@59.95Hz, auto-left, auto"
        "eDP-1, preferred, auto, 1"
      ];
    }
  ];

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

  home.stateVersion = "25.05";
}
