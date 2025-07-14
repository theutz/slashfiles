{
  config,
  lib,
  namespace,
  ...
}: let
  mod = builtins.baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  options.${namespace}.${mod}.enable = lib.mkEnableOption "enable ${namespace}";

  config = lib.mkIf cfg.enable {
    programs.noti.enable = true;
  };
}
