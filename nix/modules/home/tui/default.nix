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
  imports = lib.${namespace}.list-other-files ./.;

  options = mkOptions { };

  config = mkConfig {
    home.packages = with pkgs.${namespace}; [
      hygg
    ];
  };
}
