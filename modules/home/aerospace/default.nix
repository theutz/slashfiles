{
  lib,
  config,
  namespace,
  pkgs,
  ...
}@args:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkMod cfg;
in
mkMod [
  {
    warnings = lib.mkIf (!pkgs.stdenv.isDarwin && cfg.enable) [
      ''
        AeroSpace is only available on MacOS. This module will not be enabled.
      ''
    ];
  }

  (lib.mkIf pkgs.stdenv.isDarwin {
    home.activation.reloadAerospace =
      let
        exe = lib.getExe config.programs.aerospace.package;
      in
      config.lib.dag.entryAfter [ "writeBoundary" ]
        # bash
        ''
          verboseEcho "Attempting to reload AeroSpace config..."
          if run ${exe} reload-config; then
            verboseEcho "AeroSpace reloaded"
          else
            echo "There was a problem reloading AeroSpace config"
          fi
        '';

    programs.aerospace = {
      enable = true;
      userSettings = import ./settings.nix args;
    };
  })
]
