{lib, ...}: {
  sops = {
    templates = {
      mkSshConf' = config: {
        host,
        id,
      }: {
        "ssh/${host}.conf" = {
          content = let
            inherit (config.sops) secrets placeholder;
          in
            [
              (let label = "ssh/hosts/${host}/host"; in lib.optionalAttrs (placeholder ? label) {Host = placeholder.${label};})
            ]
            |> lib.attrsets.mergeAttrsList
            |> lib.attrsets.mapAttrsToList (name: value: "${name} ${value}")
            |> lib.strings.concatLines;
          # content = ''
          #   Host ${config.sops.placeholder."ssh/hosts/${host}/host"}
          #   Hostname ${config.sops.placeholder."ssh/hosts/${host}/hostname"}
          #   User ${config.sops.placeholder."ssh/hosts/${host}/user"}
          #   IdentityFile ${config.sops.secrets."ssh/users/${id}/priv".path}
          # '';
          owner = config.system.primaryUser;
        };
      };
    };
  };
}
