{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib.${namespace}.mkMod config ./.) mkOptions mkConfig;
in {
  imports = [./xdg.nix];

  options = mkOptions {};

  config = mkConfig {
    home.packages = with pkgs; (lib.concatLists [
      [
        slack
        zoom-us
        signal-desktop
        neovide
      ]

      (lib.optionals pkgs.stdenv.isLinux [
        brightnessctl
        playerctl
      ])
    ]);
  };
}
