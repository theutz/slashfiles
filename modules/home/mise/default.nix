{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) mkModule;
in
  mkModule {
    inherit config;
    here = ./.;
  } {
    config = {
      programs.mise = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
        globalConfig = {};
        settings = {};
      };

      programs.direnv.mise.enable = true;
    };
  }
