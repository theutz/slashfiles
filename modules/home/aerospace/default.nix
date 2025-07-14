{
  lib,
  config,
  namespace,
  pkgs,
  ...
}: let
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  options.${namespace}.${mod} = {
    enable = lib.mkEnableOption "aerospace window manager";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = pkgs.stdenv.isDarwin;
        message = "Aerospace is only available on darwin systems.";
      }
    ];

    programs.aerospace = {
      enable = true;
      userSettings = {
        gaps.outer = lib.genAttrs ["left" "right" "top" "bottom"] (_: 16);
      };
    };
  };
}
