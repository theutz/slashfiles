{
  config,
  lib,
  namespace,
  ...
}: let
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
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
