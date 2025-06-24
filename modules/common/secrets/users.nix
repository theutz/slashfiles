{
  config,
  lib,
  namespace,
  ...
}: let
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  options.${namespace}.${mod} = {
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
  };

  config = lib.mkIf cfg.enable {
    sops.secrets =
      cfg.sshKeys
      |> lib.lists.foldl (
        prev: curr:
          prev
          // {
            "ssh/users/${curr}/priv" = cfg.mine;
            "ssh/users/${curr}/pub" = cfg.shared;
          }
      ) {};
  };
}
