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
      hashKnownHosts = true;
      addKeysToAgent = "yes";

      matchBlocks = let
        privKey = name: osConfig.sops.secrets."ssh/${name}/priv".path;
        me = privKey "default";
        work = privKey "work";
      in {
        "github.com" = {
          identityFile = me;
        };
        "work.github.com" = {
          hostname = "github.com";
          identityFile = work;
          user = "delegator-system";
        };
      };
    };
  };
}
