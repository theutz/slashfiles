{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkConfig;
in
{
  config = mkConfig [
    (lib.mkIf pkgs.stdenv.isLinux {
      home.packages = with pkgs; [
        bluetui
        bluetuith
      ];

      xdg.desktopEntries = {
        bluetooth = {
          name = "Bluetooth Controls";
          exec = lib.getExe pkgs.bluetui;
          terminal = true;
          actions = {
            bluetuith = {
              name = "Open Bluetuith";
              exec = lib.getExe pkgs.bluetuith;
            };
          };
        };
      };
    })
  ];
}
