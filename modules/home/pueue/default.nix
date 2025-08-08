{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkMod mkLaunchdAgent;

  # https://github.com/Nukesor/pueue/wiki/Configuration
  settings = { };
in
mkMod [
  (lib.mkIf pkgs.stdenv.isDarwin {
    home.packages = with pkgs; [
      pueue
    ];

    launchd.agents = mkLaunchdAgent {
      ProgramArguments = [
        "${pkgs.pueue}/bin/pueued"
        "--daemonize"
      ];
    };

    xdg.configFile."pueue/pueue.yaml" = {
      source = (pkgs.formats.yaml { }).generate "pueue.yaml" settings;
      force = true;
    };
  })

  (lib.mkIf pkgs.stdenv.isLinux {
    services.pueue.enable = true;
    services.pueue.settings = settings;
  })
]
