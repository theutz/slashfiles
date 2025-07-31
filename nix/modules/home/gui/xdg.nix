{
  config,
  namespace,
  lib,
  ...
}: let
  inherit (lib.${namespace}.mkMod config ./.) cfg;
in {
  config = lib.mkIf cfg.enable {
    home.preferXdgDirectories = true;

    xdg.enable = true;
    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/terminal" = ["org.wezfurlong.wezterm.desktop"];
    };

    home.sessionVariables = {
      XDG_DOWNLOAD_DIR = "${config.home.homeDirectory}/Downloads";
    };
  };
}
