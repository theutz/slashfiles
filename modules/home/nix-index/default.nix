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
  home.packages = with pkgs; [
    comma
  ];

  programs.nix-index = {
    enable = true;
  };
}
