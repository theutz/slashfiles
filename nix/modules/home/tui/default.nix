{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.slashfiles.mkMod config ./.) mkOptions mkConfig;
in {
  imports = lib.slashfiles.list-other-files ./.;

  options = mkOptions {};

  config = mkConfig {
    home.packages = with pkgs; [
      slashfiles.hygg
    ];
  };
}
