{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkMod;
in
mkMod [
  (lib.mkIf pkgs.stdenv.isLinux {
    home.packages = with pkgs; [
      signal-desktop
    ];
  })

  (lib.mkIf pkgs.stdenv.isDarwin {
    home.activation.checkSignalDesktop =
      config.lib.dag.entryAfter [ "writeBoundary" ]
        # bash
        ''
          if /opt/homebrew/bin/brew list signal; then
            verboseEcho "Signal installed"
          else
            errorEcho "Formula 'signal' not found"
            exit 1
          fi
        '';
  })
]
