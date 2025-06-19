{
  config,
  lib,
  pkgs,
  ...
}: let
  tomlFormat = pkgs.formats.toml {};
in
  lib.slashfiles.mkModule {
    inherit config;
    here = ./.;
  } {
    config = {
      home.packages = with pkgs; [
        chawan
        libsixel
      ];

      xdg.configFile."chawan/config.toml" = {
        executable = false;
        source = tomlFormat.generate "chawan-config" {
          buffer = {
            images = true;
          };
        };
      };
    };
  }
