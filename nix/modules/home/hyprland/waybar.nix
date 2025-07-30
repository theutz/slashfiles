{
  namespace,
  lib,
  config,
  ...
}: let
  cfg = config.${namespace}.${mod};
  mod = baseNameOf ./.;
in {
  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;

      settings = {};

      style =
        # css
        ''
        '';
    };
  };
}
