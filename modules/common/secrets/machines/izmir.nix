{
  config,
  namespace,
  lib,
  ...
}: let
  mod = baseNameOf ../.;
  host = baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  config = lib.mkIf cfg.enable {
    sops.templates."ssh/${host}.conf" = '''';
  };
}
