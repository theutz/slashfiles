{
  lib,
  config,
  namespace,
  ...
}: let
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  options.${namespace}.${mod} = {
    enable = lib.mkEnableOption "aerospace window manager";
  };

  config = lib.mkIf cfg.enable {
    programs.aerospace = {
      enable = true;
      userSettings = {
        gaps.outer = lib.genAttrs ["left" "right" "top" "bottom"] (_: 16);
      };
    };
  };
}
