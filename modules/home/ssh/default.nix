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
      enable = true;
      matchBlocks = {
        "github.com" = {
          identityFile = osConfig.sops.secrets."ssh/default/priv".path;
        };
      };
    };
  };
}
