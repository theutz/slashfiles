{
  namespace,
  lib,
  config,
  ...
}: let
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  options.${namespace}.${mod} = {
    enable = lib.mkEnableOption "secrets config";

    sshKeys = lib.mkOption {
      type = with lib.types; listOf str;
      description = ''
        SSH key "names" to create secrets for.
      '';
      default = [
        "mor"
        "koyu_mor"
        "beyaz"
        "yesil"
        "pembe"
        "gri"
        "sari"
        "gumus"
      ];
    };

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
      default = cfg.mine // {mode = "0444";};
    };
  };
}
