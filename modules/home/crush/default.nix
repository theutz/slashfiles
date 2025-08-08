{
  config,
  namespace,
  lib,
  pkgs,
  ...
} @args:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkMod;
in
mkMod {
  home.packages = with pkgs; [
    nur.repos.charmbracelet.crush
  ];

  xdg.configFile."crush/crush.json" = {
    text = builtins.toJSON (import ./config.nix args);
  };
}
