{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.slashfiles.mkMod config ./.) mkConfig mkOptions;
in {
  options = mkOptions {};

  config = mkConfig {
    home.packages = with pkgs; [
      nyxt
    ];

    # programs.nyxt = {
    #   enable = true;
    # };
  };
}
