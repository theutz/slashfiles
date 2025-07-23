{ pkgs, lib, namespace, config, ... }: let
  mod = builtins.baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  options.${namespace}.${mod}.enable = lib.mkEnableOption "enable ${mod}";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [wiremix];

    xdg.desktopEntries.wiremix = {
      name = "WireMix";
      exec = "wiremix";
      terminal = true;
    };
  };
}
