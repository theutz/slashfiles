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
      defaultSopsFile = ./secrets.yaml;
      secrets = {
        "spotify_player/client_id" = {
          owner = "michael";
          group = "staff";
          mode = "0400";
        };
      };
    };
  };
}
