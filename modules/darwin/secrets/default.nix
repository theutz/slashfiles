{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib.trivial) flip;
  inherit (lib.attrsets) genAttrs mergeAttrsList;
  inherit (lib.${namespace}) mkModule;
  inherit (lib.${namespace}.secrets.sops.templates) mkSshConf;
  mkSshConf' = mkSshConf config;

  owner = config.system.primaryUser;
  mkMine = (flip genAttrs) (_: {inherit owner;});
  mkShared = (flip genAttrs) (_: {
    inherit owner;
    mode = "0444";
  });
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
        templates = mergeAttrsList [
          (mkSshConf' "izmir" "yesil")
          (mkSshConf' "istanbul" "yesil")
        ];

        defaultSopsFile = ../../../secrets.yaml;

        secrets =
          (mkMine [
            "ssh/hosts/izmir/host"
            "ssh/hosts/izmir/user"
            "ssh/hosts/izmir/hostname"

            "ssh/hosts/istanbul/host"
            "ssh/hosts/istanbul/user"
            "ssh/hosts/istanbul/hostname"

            "ssh/users/mor/priv"

            "ssh/users/yesil/priv"

            "spotify_player/client_id"
          ])
          // (mkShared [
            "ssh/users/mor/pub"
            "ssh/users/yesil/pub"
          ]);
      };
    };
  }
