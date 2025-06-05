{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib.attrsets) genAttrs;
  inherit (lib.${namespace}) mkModule;
  inherit (lib.${namespace}.secrets.sops.templates) mkSshConf';
  mkSshConf = mkSshConf' config;
in
  mkModule {
    inherit config;
    here = ./.;
  } {
    config = {
      environment.systemPackages = with pkgs; [
        sops
        age
      ];

      sops = {
        templates = lib.attrsets.mergeAttrsList [
          (mkSshConf {
            host = "izmir";
            id = "yesil";
          })
        ];

        defaultSopsFile = ../../../secrets.yaml;

        secrets = let
          mkMine = k: genAttrs k (_: {owner = config.system.primaryUser;});

          mkShared = k:
            genAttrs k (_: {
              owner = config.system.primaryUser;
              mode = "0444";
            });
        in
          (mkMine [
            "ssh/hosts/izmir/host"
            "ssh/hosts/izmir/user"
            "ssh/hosts/izmir/hostname"
            "ssh/users/mor/priv"
            "ssh/users/yesil/priv"
            "spotify_player/client_id"
          ])
          // (mkShared [
            "ssh/users/mor/pub"
            "ssh/users/yesil/pub"
          ]);
        # in {
        #   "ssh/hosts/izmir/host" = mine;
        #   "ssh/hosts/izmir/user" = mine;
        #   "ssh/hosts/izmir/hostname" = mine;
        #
        #   "ssh/users/mor/priv" = mine;
        #   "ssh/users/mor/pub" = shared;
        #
        #   "ssh/users/yesil/priv" = mine;
        #   "ssh/users/yesil/pub" = shared;
        #
        #   "spotify_player/client_id" = mine;
        # };
      };
    };
  }
