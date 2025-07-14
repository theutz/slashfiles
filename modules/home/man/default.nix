{
  pkgs,
  namespace,
  lib,
  config,
  ...
}: let
  mod = builtins.baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  options.${namespace}.${mod}.enable = lib.mkEnableOption "enable ${mod}";

  config = lib.mkIf cfg.enable {
    programs.man = {
      enable = true;
      generateCaches = true; # can slow down builds
    };

    home.sessionVariables = {
      MANPAGER = "${lib.getExe pkgs.${namespace}.nvf} -c +Man!";
      MANWIDTH = 999;
    };
  };
}
