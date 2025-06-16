{
  pkgs,
  namespace,
  lib,
  config,
  ...
}:
lib.slashfiles.mkModule {
  inherit config;
  here = ./.;
} {
  config = {
    programs.man = {
      enable = lib.traceVal true;
      generateCaches = true; # can slow down builds
    };

    home.sessionVariables = {
      MANPAGER = "${lib.getExe pkgs.${namespace}.nvf} -c +Man!";
      MANWIDTH = 999;
    };
  };
}
