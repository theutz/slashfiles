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
      includes = [
        osConfig.sops.templates."ssh/izmir.conf".path
      ];

      matchBlocks = let
        privKey = name: osConfig.sops.secrets."ssh/users/${name}/priv".path;
        me = privKey "mor";
        work = privKey "yesil";
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
