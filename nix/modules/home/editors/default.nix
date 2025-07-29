{
  config,
  pkgs,
  lib,
  namespace,
  ...
}: let
  inherit (builtins) baseNameOf;
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};
  inherit (lib) mkIf mkEnableOption;
  inherit (pkgs.${namespace}) nvf;
  nvim = lib.getExe nvf;
in {
  options.${namespace}.${mod}.enable = mkEnableOption "enable ${mod}";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nvf
      wl-clipboard
    ];

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
