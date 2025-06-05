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
      matchBlocks = let
        privKey = name: osConfig.sops.secrets."ssh/${name}/priv".path;
        me = privKey "default";
      in {
        "github.com" = {
          identityFile = me;
        };
      };
    };
  };
}
