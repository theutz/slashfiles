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
  inherit (lib.${namespace}.mkMod config ./.) mkOptions mkConfig;
  nvim = lib.getExe pkgs.${namespace}.nvf;
in
{
  options = mkOptions { };

  config = mkConfig {
    home.packages =
      with pkgs;
      [
        wl-clipboard
        inputs.nvf.packages.${system}.docs-manpages
      ]
      ++ (with pkgs.${namespace}; [
        nvf
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
  };
}
