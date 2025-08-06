{
  namespace,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.${namespace}.mkMod config ./.) mkOptions mkConfig;
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  options = mkOptions { };

  config = mkConfig [
    {
      home.packages = with pkgs; [
        qutebrowser
      ];

      xdg.configFile."qutebrowser" = {
        source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${namespace}/nix/modules/home/gui/browsers/qutebrowser/personal";
        recursive = true;
      };

      xdg.configFile."qutebrowser-work/config" = {
        source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${namespace}/nix/modules/home/gui/browsers/qutebrowser/work";
        recursive = true;
      };

      xdg.desktopEntries = {
        browser = {
          name = "Web Browser";
          exec = "qutebrowser";
          actions = {
            work = {
              name = "Work Profile";
              exec = "qutebrowser -B ${config.xdg.configHome}/qutebrowser-work";
            };
          };
        };
      };
    }
  ];
}
