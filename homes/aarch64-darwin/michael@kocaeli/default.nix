{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib.${namespace}) genEnabledMods;
in
{
  home.packages = with pkgs; [
    neovim
    chezmoi
  ];

  programs.nh = {
    enable = true;
  };

  # ${namespace} = (genEnabledMods (import ./mods.nix));

  # home = {
  #   sessionPath = [
  #     osConfig.homebrew.brewPrefix
  #   ];
  #
  #   shell = {
  #     # Enables in all shells
  #     enableShellIntegration = true;
  #   };
  # };
  #
  # programs = {
  #   home-manager = {
  #     enable = true;
  #   };
  # };

  sops.age.keyFile = config.xdg.configHome + "/sops/age/keys.txt";

  home.stateVersion = "25.05";
}
