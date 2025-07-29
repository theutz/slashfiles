{ config, pkgs, lib, namespace, ... }: let
  mod = builtins.baseNameOf ./.;
  cfg = config.${namespace}.${mod};
  inherit (lib) mkEnableOption mkIf mkMerge;
in {
  options.${namespace}.${mod} = {
    enable = mkEnableOption "enable ${mod} modules";
    enableWorkstation = mkEnableOption "enable ${mod} workstation modules";
  };

  config = mkIf cfg.enable {
    ${namespace} = mkMerge [
      {
        lazyvim.enable = true;
        shells.enable = true;
      }
      
      (mkIf cfg.enableWorkstation {
        qutebrowser.enable = true;
        wezterm.enable = true;
        hypr.enable = true;
      })
    ];
  };
}
