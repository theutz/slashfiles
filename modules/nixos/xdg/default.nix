{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  mod = builtins.baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  options.${namespace}.${mod}.enable = lib.mkEnableOption "enable ${mod}";

  config = lib.mkIf cfg.enable {
    xdg.terminal-exec = {
      enable = true;
      settings = {
        default = ["org.wezfurlong.wezterm.desktop"];
      };
    };
  };
}
