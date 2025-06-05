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
      templates = {
        "ssh/izmir.conf" = {
          content = ''
            Host ${config.sops.placeholder."ssh/hosts/izmir/host"}
            Hostname ${config.sops.placeholder."ssh/hosts/izmir/hostname"}
            User ${config.sops.placeholder."ssh/hosts/izmir/user"}
            IdentityFile ${config.sops.secrets."ssh/users/yesil/priv".path}
          '';
          owner = config.system.primaryUser;
        };
      };

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
        "ssh/hosts/izmir/host" = mine;
        "ssh/hosts/izmir/user" = mine;
        "ssh/hosts/izmir/hostname" = mine;

        "ssh/users/mor/priv" = mine;
        "ssh/users/mor/pub" = shared;

        "ssh/users/yesil/priv" = mine;
        "ssh/users/yesil/pub" = shared;

        "spotify_player/client_id" = mine;
      };
    };
  };
}
