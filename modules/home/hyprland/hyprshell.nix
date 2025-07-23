{
  namespace,
  config,
  lib,
  ...
}: let
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  config = lib.mkIf cfg.enable {
    programs.hyprshell = {
      enable = true;
    };
  };
}
