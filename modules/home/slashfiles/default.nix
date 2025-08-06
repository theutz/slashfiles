{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkConfig mkOptions;
in
{
  options = mkOptions { };

  config = mkConfig {
    home.packages = with pkgs.${namespace}; [
      sesh
    ];
  };
}
