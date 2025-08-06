{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.mkMod config ./.) mkOptions mkConfig;
in
{
  imports = [ ./xdg.nix ];

  options = mkOptions { };

  config = mkConfig [
    {
      home.packages = with pkgs; [
        slack
        zoom-us
        neovide
      ];
    }

    (lib.mkIf pkgs.stdenv.isLinux {
      home.packages = with pkgs; [
        brightnessctl
        playerctl
        signal-desktop
      ];
    })

    (lib.mkIf pkgs.stdenv.isDarwin {
      home.packages = with pkgs; [
      ];
    })
  ];
}
