_: {
  sops = {
    templates = {
      mkSshConf = {
        config,
        host,
        id,
        ...
      }: {
        "ssh/${host}.conf" = {
          content = ''
            Host ${config.sops.placeholder."ssh/hosts/${host}/host"}
            Hostname ${config.sops.placeholder."ssh/hosts/${host}/hostname"}
            User ${config.sops.placeholder."ssh/hosts/${host}/user"}
            IdentityFile ${config.sops.secrets."ssh/users/${id}/priv".path}
          '';
          owner = config.system.primaryUser;
        };
      };
    };
  };
}
