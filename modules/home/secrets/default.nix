{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkMod;

  mkSshKeyPair =
    name:
    let
      sopsFile = lib.snowfall.fs.get-file "secrets/ssh.yaml";
      mkPath = name: "${config.home.homeDirectory}/.ssh/${name}";
    in
    {
      "${name}/pri" = {
        inherit sopsFile;
        path = mkPath name;
      };
      "${name}/pub" = {
        inherit sopsFile;
        path = mkPath "${name}.pub";
      };
    };
in
mkMod {
  sops.age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
  sops.secrets = lib.attrsets.mergeAttrsList [
    (mkSshKeyPair "id_ed25519")
    (mkSshKeyPair "id_rsa")
  ];
}
