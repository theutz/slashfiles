{
  lib,
  pkgs,
  inputs,
  system,
  config,
  ...
}: let
  inherit (lib.slashfiles.mkMod config ./.) mkConfig;
  wiremix = inputs.wiremix.packages.${system}.default;
  exe = lib.getExe' wiremix "wiremix";
in {
  config = mkConfig {
    home.packages = with pkgs; [
      wiremix
    ];

    xdg.desktopEntries.volume = {
      name = "Volume Controls";
      exec = "${exe} -v output";
      terminal = true;
      actions = {
        mixer = {
          name = "Application mixer";
          exec = "${exe} -v playback";
        };
      };
    };
  };
}
