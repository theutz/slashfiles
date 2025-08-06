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

    programs.nh = {
      enable = true;
      package = inputs.nh.packages.${system}.default;
      clean.enable = true;
      flake = lib.concatStringsSep "/" [config.home.homeDirectory namespace];
    };

    programs.fd.enable = true;

    programs.ripgrep.enable = true;

    programs.zoxide.enable = true;

    programs.ftdv.enable = true;

    programs.yatto.enable = true;
  };
}
