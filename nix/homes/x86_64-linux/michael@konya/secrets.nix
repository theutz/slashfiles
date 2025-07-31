{
  config,
  lib,
  ...
}: {
  sops.age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
  sops.secrets = let
    sopsFile = lib.snowfall.fs.get-file "secrets/ssh.yaml";
    mkPath = name: "${config.home.homeDirectory}/.ssh/${name}";
  in {
    id_ed25519 = {
      inherit sopsFile;
      path = mkPath "id_ed25519";
    };

    id_ed25519_pub = {
      inherit sopsFile;
      path = mkPath "id_ed25519.pub";
    };
  };
}
