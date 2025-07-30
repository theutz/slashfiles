{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (builtins) baseNameOf;
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};
  inherit (lib) mkIf mkEnableOption;
in {
  options.${namespace}.${mod}.enable = mkEnableOption "enable ${mod}";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      spotify
    ];

    programs.spotify-player = {
      enable = true;
    };
  };
}
