{
  lib,
  config,
  pkgs,
  osConfig,
  ...
}:
lib.slashfiles.mkModule {
  here = ./.;
  inherit config;
} {
  config = {
    programs.ssh = {
      matchBlocks = {
        "github.com" = {
          identityFile = osConfig.sops.secrets."ssh/default/priv".path;
        };
      };
    };
  };
}
