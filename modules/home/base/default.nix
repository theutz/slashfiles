{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkMerge;
  inherit (lib.${namespace}.mkMod' config ./.)
    mkOptions
    mkConfig
    cfg
    mod
    ;
in
{
  imports = lib.${namespace}.list-other-files ./.;

  options = mkOptions {
    enableWorkstation = mkEnableOption "enable ${mod} workstation modules";
  };

  config = mkConfig {
    ${namespace} = mkMerge [
      {
        shells.enable = true;
        editors.enable = true;
        cli.enable = true;
        tui.enable = true;
      }

      (mkIf cfg.enableWorkstation {
        terminals.enable = true;
        media.enable = true;
        gui.enable = true;
      })

      (mkIf (cfg.enableWorkstation && pkgs.stdenv.isLinux) {
        hyprland.enable = true;
      })
    ];
  };
}
