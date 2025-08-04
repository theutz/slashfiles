{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge;
  inherit (lib.slashfiles.mkMod config ./.) mkOptions mkConfig cfg mod;
in {
  options = mkOptions {
    enableWorkstation = mkEnableOption "enable ${mod} workstation modules";
  };

  config = mkConfig {
    slashfiles = mkMerge [
      {
        shells.enable = true;
        editors.enable = true;
        cli.enable = true;
        tui.enable = true;
        slashfiles.enable = true;
      }

      (mkIf cfg.enableWorkstation {
        qutebrowser.enable = true;
        nyxt.enable = true;
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
