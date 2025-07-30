{
  config,
  pkgs,
  lib,
  namespace,
  ...
}: let
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
        shells.enable = true;
        editors.enable = true;
        cli.enable = true;
        tui.enable = true;
      }

      (mkIf cfg.enableWorkstation {
        qutebrowser.enable = true;
        terminals.enable = true;
        hypr.enable = true;
        media.enable = true;
      })
    ];
  };
}
