{
  config,
  namespace,
  lib,
  ...
}: let
  mod = baseNameOf ../.;
  cfg = config.${namespace}.${mod};

  host = lib.${namespace}.thisHere __curPos;

  user = "pembe";
  mine = {owner = cfg.primaryUser;};
in {
  config = lib.mkIf cfg.enable {
    sops = {
      secrets = {
        "ssh/hosts/${host}/host" = mine;
        "ssh/hosts/${host}/user" = mine;
        "ssh/hosts/${host}/hostname" = mine;
      };

      templates."ssh/${host}.conf" =
        mine
        // {
          content = ''
            Host ${config.sops.placeholder."ssh/hosts/${host}/host"}
            Hostname ${config.sops.placeholder."ssh/hosts/${host}/hostname"}
            User ${config.sops.placeholder."ssh/hosts/${host}/user"}
            IdentityFile ${config.sops.secrets."ssh/users/${user}/priv".path}
          '';
        };
    };
  };
}
