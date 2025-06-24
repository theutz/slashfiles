{
  config,
  namespace,
  lib,
  ...
}: let
  mod = baseNameOf ../.;
  cfg = config.${namespace}.${mod};

  host = lib.${namespace}.thisHere __curPos;

  user = "yesil";
in {
  config = lib.mkIf cfg.enable {
    sops = {
      secrets = {
        "ssh/hosts/${host}/host" = cfg.mine;
        "ssh/hosts/${host}/user" = cfg.mine;
      };

      templates."ssh/${host}.conf" =
        cfg.mine
        // {
          content = ''
            Host ${config.sops.placeholder."ssh/hosts/${host}/host"}
            User ${config.sops.placeholder."ssh/hosts/${host}/user"}
            IdentityFile ${config.sops.secrets."ssh/users/${user}/priv".path}
          '';
        };
    };
  };
}
