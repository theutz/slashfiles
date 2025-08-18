{
  config,
  pkgs,
  lib,
  namespace,
  inputs,
  system,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkMod;
  nvim = lib.getExe pkgs.${namespace}.nvf;
in
mkMod {
  home.packages = [
    pkgs.${namespace}.nvf
    inputs.nvf.packages.${system}.docs-manpages
  ]
  ++ (lib.optionals pkgs.stdenv.isLinux [
    pkgs.wl-clipboard
  ]);

  home.sessionVariables = {
    VISUAL = nvim;
    EDITOR = nvim;
    MANPAGER = "${nvim} +Man!";
    MANWIDTH = 999;
  };

  home.shellAliases = {
    vi = nvim;
    vim = nvim;
    vimdiff = "${nvim} -d";
  };
}
