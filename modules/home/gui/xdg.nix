{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkConfig;
in
{
  config = mkConfig (
    lib.mkMerge [
      {
        home.preferXdgDirectories = true;

        xdg.enable = true;

      }
      (lib.mkIf pkgs.stdenv.isLinux {
        xdg.mimeApps.defaultApplications =
          let
            qtb = "org.qutebrowser.qutebrowser.desktop";
          in
          {
            "text/html" = qtb;
            "x-scheme-handler/http" = qtb;
            "x-scheme-handler/https" = qtb;
            "x-scheme-handler/about" = qtb;
            "x-scheme-handler/unknown" = qtb;
            "x-scheme-handler/terminal" = [ "org.wezfurlong.wezterm.desktop" ];
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
      })
    ]
  );
}
