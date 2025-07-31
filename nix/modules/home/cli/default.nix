{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.slashfiles.mkMod config ./.) mkOptions mkConfig;
in {
  imports = [
    ./bat.nix
  ];

  options = mkOptions {};

  config = mkConfig {
    home.packages = with pkgs; (lib.concatLists [
      (lib.optionals pkgs.stdenv.isLinux [])
    ]);

    programs.fd.enable = true;
    programs.ripgrep.enable = true;

    programs.direnv.enable = true;
    programs.direnv.mise.enable = true;
    programs.direnv.nix-direnv.enable = true;
  };
}
