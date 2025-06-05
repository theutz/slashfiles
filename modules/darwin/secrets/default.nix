{
  pkgs,
  lib,
  config,
  namespace,
  ...
}:
lib.${namespace}.mkModule {
  inherit config;
  here = ./.;
} {
  config = {
    environment.systemPackages = with pkgs; [
      sops
      age
    ];

    sops = {
      defaultSopsFile = ../../../secrets.yaml;

      secrets = let
        mine = {
          owner = config.system.primaryUser;
          mode = "0400";
        };

        shared =
          mine
          // {
            mode = "0444";
          };
      in {
        "spotify_player/client_id" = mine;

        "ssh/default/priv" = mine;
        "ssh/default/pub" = shared;
        "ssh/work/priv" = mine;
        "ssh/work/pub" = shared;
      };
    };
  };
}
