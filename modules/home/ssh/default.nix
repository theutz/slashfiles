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
        work = privKey "work";
      in {
        "github.com" = {
          identityFile = me;
        };
        "work.github.com" = {
          host = "github.com";
          identityFile = work;
        };
      };
    };
  };
}
