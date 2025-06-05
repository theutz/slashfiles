{
  sops = {
    templates = {
      mkSshConf = {config, ...}: {
        "ssh/izmir.conf" = {
          content = ''
            Host ${config.sops.placeholder."ssh/hosts/izmir/host"}
            Hostname ${config.sops.placeholder."ssh/hosts/izmir/hostname"}
            User ${config.sops.placeholder."ssh/hosts/izmir/user"}
            IdentityFile ${config.sops.secrets."ssh/users/yesil/priv".path}
          '';
          owner = config.system.primaryUser;
      };
    };
  };
}
