{
  config,
  namespace,
  lib,
  ...
}: let
  mod = baseNameOf ../.;
  host = baseNameOf ./.;
  user = "yesil";
  cfg = config.${namespace}.${mod};
in {
  config = lib.mkIf cfg.enable {
    sops.templates."ssh/${host}.conf" = {
      owner = cfg.primaryUser;
      content = ''
        Host ${config.sops.placeholder."ssh/hosts/${host}/host"}
        Hostname ${config.sops.placeholder."ssh/hosts/${host}/hostname"}
        User ${config.sops.placeholder."ssh/hosts/${host}/user"}
        IdentityFile ${config.sops.secrets."ssh/users/${user}/priv".path}
      '';
    };
  };
}
