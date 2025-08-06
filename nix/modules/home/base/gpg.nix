{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.mkMod config ./.) mkConfig;
in
{
  config = mkConfig {
    programs.gpg = {
      enable = true;
      settings = {
        auto-key-retrieve = true;
        no-emit-version = true;
        default-key = "20EAD87446896C423CA9C6C1651A36416AEFB22E";
        keyid-format = "SHORT";
        armor = true;
      };
    };

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 84000;
      maxCacheTtl = 84000;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      # default-cache-ttl 84000
      # max-cache-ttl 84000
      # pinentry-program /opt/homebrew/bin/pinentry-mac
    };
  };
}
