{lib, ...}: {
  sops = {
    templates = {
      mkSshConf = config: host: id: {
        "ssh/${host}.conf" = {
          content = let
            inherit (config.sops) secrets placeholder;
          in
            [
              (let
                label = "ssh/hosts/${host}/host";
                hasLabel = placeholder ? ${label};
                value = placeholder.${label};
              in
                lib.optionalAttrs hasLabel {Host = value;})

              (let
                label = "ssh/hosts/${host}/hostname";
                hasLabel = placeholder ? ${label};
                value = placeholder.${label};
              in
                lib.optionalAttrs hasLabel {Hostname = value;})

              (let
                label = "ssh/hosts/${host}/user";
                hasLabel = placeholder ? ${label};
                value = placeholder.${label};
              in
                lib.optionalAttrs hasLabel {User = value;})

              (let
                label = "ssh/users/${id}/priv";
                hasLabel = secrets ? ${label};
                inherit (secrets.${label}) path;
              in
                lib.optionalAttrs hasLabel {IdentityFile = path;})
            ]
            |> lib.attrsets.mergeAttrsList
            |> lib.attrsets.mapAttrsToList (name: value: "${name} ${value}")
            |> lib.strings.concatLines;
          owner = config.system.primaryUser;
        };
      };
    };
  };
}
