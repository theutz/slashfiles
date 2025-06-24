{
  lib,
  config,
  osConfig,
  namespace,
  pkgs,
  ...
}: let
  cfg = config.${namespace}.${mod};
  mod = baseNameOf ./.;
  inherit (osConfig) sops;
  inherit (sops) templates secrets;
in {
  options.${namespace}.${mod} = {
    enable = lib.mkEnableOption "Manage SSH";

    sopsTemplates = lib.mkOption {
      description = ''
        List of SSH template basenames created by sops-nix to include in the
        ssh config. These will generally correlate with the machine names.
      '';
      type = with lib.types; listOf str;
      default = [
        "izmir"
        "istanbul"
        "mugla"
        "eskisehir"
        "sakarya"
        "manisa"
        "batman"
        "sanliurfa"
        "erzurum"
        "bursa"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    services.ssh-agent.enable = pkgs.stdenv.isLinux;

    programs.ssh = {
      enable = true;
      hashKnownHosts = true;
      addKeysToAgent = "yes";
      includes = cfg.sopsTemplates |> (map (host: templates."ssh/${host}.conf".path));

      matchBlocks = let
        mkPrivKeyPath = user: secrets."ssh/users/${user}/priv".path;
        me = mkPrivKeyPath "mor";
        work = mkPrivKeyPath "yesil";
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
