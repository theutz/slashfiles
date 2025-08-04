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
    home.packages = with pkgs; (lib.concatLists [
      [
        sops
      ]
      (lib.optionals pkgs.stdenv.isLinux [])
    ]);

    programs.fd.enable = true;
    programs.ripgrep.enable = true;

    programs.zoxide.enable = true;

    programs.ftdv.enable = true;

    programs.yatto.enable = true;
  };
}
