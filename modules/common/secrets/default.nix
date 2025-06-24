{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  imports = (./machines |> lib.filesystem.listFilesRecursive) ++ [./users.nix];

  options.${namespace}.${mod} = {
    enable = lib.mkEnableOption "secrets config";

    primaryUser = lib.mkOption {
      type = with lib.types; nullOr str;
      default = lib.${namespace}.prefs.user;
      description = ''
        The username of the primary, non-root user that can access the secrets.
      '';
    };

    mine = lib.mkOption {
      type = lib.types.attrs;
      description = ''
        Definition of a secret that is only visible to the primary user.
      '';
      default = {owner = cfg.primaryUser;};
    };

    shared = lib.mkOption {
      type = lib.types.attrs;
      description = ''
        definition of a secret that is owned by the primary user, but is
        world-readable;
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    ${namespace}.${mod} = {
      shared = cfg.mine // {mode = "0444";};
    };

    environment.systemPackages = with pkgs; [
      sops
      age
    ];

    sops = {
      defaultSopsFile = ../../../secrets.yaml;

      secrets = {
        "spotify_player/client_id" = cfg.mine;

        "openai" = cfg.mine;
        "gemini" = cfg.mine;
        "anthropic" = cfg.mine;
      };
    };
  };
}
