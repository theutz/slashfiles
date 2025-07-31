{
  config,
  lib,
  ...
}: let
  inherit (lib.slashfiles.mkMod config ./.) mkConfig;
in {
  config = mkConfig {
    xdg.desktopEntries.wifi = {
      name = "WiFi Controls";
      exec = "nmtui connect";
      terminal = true;
      actions = {
        edit = {
          name = "Edit Connection";
          exec = "nmtui edit";
        };
        all = {
          name = "All Settings";
          exec = "nmtui";
        };
      };
    };
  };
}
