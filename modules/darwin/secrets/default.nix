{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib.trivial) flip;
  inherit (lib.attrsets) genAttrs mergeAttrsList;
  inherit (lib.lists) concatLists flatten;
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
          (mkSshConf' "ankara" "beyaz")
          (mkSshConf' "mugla" "pembe")
          (mkSshConf' "sakarya" "mor")
          (mkSshConf' "eskisehir" "yesil")
          (mkSshConf' "manisa" "yesil")
          (mkSshConf' "batman" "yesil")
        ];

        defaultSopsFile = ../../../secrets.yaml;

        secrets = let
          users = [
            "mor"
            "koyu_mor"
            "beyaz"
            "yesil"
            "pembe"
            "gri"
            "sari"
            "gumus"
          ];

          hosts = [
            "izmir"
            "istanbul"
            "ankara"
            "mugla"
            "eskisehir"
            "sakarya"
            "manisa"
          ];
        in
          (mkMine (concatLists [
            [
              "spotify_player/client_id"
            ]
            (users |> map (u: "ssh/users/${u}/priv"))
            (hosts
              |> (map (h: [
                "ssh/hosts/${h}/host"
                "ssh/hosts/${h}/user"
                "ssh/hosts/${h}/hostname"
              ]))
              |> flatten)
          ]))
          // (mkShared (users
              |> map (u: "ssh/users/${u}/pub")));
      };
    };
  }
