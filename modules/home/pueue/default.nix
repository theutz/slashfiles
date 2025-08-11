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
  settings = {
    shared = {
      unix_socket_path = lib.concatStringsSep "/" [
        config.xdg.dataHome
        "pueue"
        "pueue_${config.home.username}.socket"
      ];
      runtime_directory = config.home.homeDirectory;
    };
  };
in
mkMod [
  {
    home.sessionVariables.PUEUE_CONFIG_PATH = lib.concatStringsSep "/" [
      config.home.homeDirectory
      config.xdg.configFile."pueue/pueue.yaml".target
    ];
  }

  (lib.mkIf pkgs.stdenv.isDarwin {
    home.packages = with pkgs; [
      pueue
    ];

    home.activation.pueueDirs =
      config.lib.dag.entryBefore [ "setupLaunchAgents" ] # bash
        ''
          RUNTIME_DIR="''$(dirname ${settings.shared.unix_socket_path})"
          verboseEcho "RUNTIME_DIR: ''${RUNTIME_DIR}"
          if [[ -d "$RUNTIME_DIR" ]]; then
            verboseEcho "$RUNTIME_DIR exists"
          else
            echo "Creating ''$RUNTIME_DIR"
            run mkdir -p ''$RUNTIME_DIR
            echo "Success"
          fi
        '';

    launchd.agents = mkLaunchdAgent {
      KeepAlive = true;
      ProgramArguments = [
        "${pkgs.pueue}/bin/pueued"
        "-c"
        config.home.sessionVariables.PUEUE_CONFIG_PATH
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
