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
    home.packages = with pkgs; [
      libsixel
    ];

    programs.chawan = {
      enable = true;
      settings = {buffer = {images = true;};};
    };
  };
}
