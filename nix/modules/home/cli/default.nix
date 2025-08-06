{
  config,
  lib,
  pkgs,
  namespace,
  system,
  inputs,
  ...
}:
let
  inherit (lib.${namespace}.mkMod config ./.) mkOptions mkConfig;
in
{
  imports = lib.${namespace}.list-other-files ./.;

  options = mkOptions { };

  config = mkConfig {
    home.packages =
      with pkgs;
      (lib.concatLists [
        [
          sops
        ]
        (lib.optionals pkgs.stdenv.isLinux [ ])
      ]);

    programs.fd.enable = true;

    programs.ripgrep.enable = true;

    programs.zoxide.enable = true;

    programs.ftdv.enable = true;

    programs.yatto.enable = true;
  };
}
