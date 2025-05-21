# vim: et ts=2 sts=2 sw=2
{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.vim
    pkgs.lazygit
    pkgs.just
  ];

  nix.settings.experimental-features = "nix-command flakes";

  programs.fish.enable = true;
  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
