{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkMod;
in
mkMod {
  programs.nushell = {
    enable = true;
    plugins = with pkgs.nushellPlugins; [
      query
      gstat
    ];
  };
}
