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

    xdg.desktopEntries = {
      nixos-manual = {
        name = "NixOS Configuration Manual";
        exec = "man 5 configuration.nix";
        terminal = true;
      };

      home-mananager-manual = {
        name = "Home Manager Configuration Manual";
        exec = "man 5 home-configuration.nix";
        terminal = true;
      };

      nvf-manual = {
        name = "nvf Configuration manual";
        exec = "man 5 nvf";
        terminal = true;
      };
    };
  };
}
