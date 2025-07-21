{
  config,
  namespace,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};

  settingsFormat = pkgs.formats.yaml {};
  settingsFile = settingsFormat.generate "glance.yml" cfg.settings;
  Label = "com.${namespace}.${mod}";
  log-dir = "/tmp/${Label}";

  tail-glance = pkgs.writeShellApplication {
    name = "tail-glance";
    runtimeInputs = with pkgs; [lnav];
    text =
      # bash
      ''
        lnav ${log-dir}/*.log
      '';
  };

  port = "GLANCE_PORT_FILE";
  name = "GLANCE_REDDIT_APP_NAME_FILE";
  id = "GLANCE_REDDIT_APP_ID_FILE";
  secret = "GLANCE_REDDIT_APP_SECRET_FILE";
  envVars = {
    ${port} = osConfig.sops.secrets."glance/port".path;
    ${name} = osConfig.sops.secrets."glance/reddit/name".path;
    ${id} = osConfig.sops.secrets."glance/reddit/id".path;
    ${secret} = osConfig.sops.secrets."glance/reddit/secret".path;
  };
in {
  options.${namespace}.${mod} = {
    enable = lib.mkEnableOption "enable ${mod}";

    settings = lib.mkOption {
      inherit (settingsFormat) type;
      default = {};
      description = ''
        Configuration written to a yaml file that is read by glance. See
        <https://github.com/glanceapp/glance/blob/main/docs/configuration.md>
        for more.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    "${namespace}".${mod}.settings =
      lib.mkDefault
      (import ./glance.nix {inherit lib port name id secret;});

    home.sessionVariables = envVars;

    home.packages = with pkgs; [glance tail-glance];

    home.activation.restartGlance = lib.mkIf pkgs.stdenv.isDarwin (config.lib.dag.entryAfter ["writeBoundary"] ''
      uid="''$(id -u ${lib.${namespace}.prefs.user})"
      verboseEcho "Restarting glance"
      run /bin/launchctl kickstart -k "gui/''${uid}/${Label}"
    '');

    xdg.configFile."glance/glance.yml" = lib.mkIf pkgs.stdenv.isDarwin {
      source = settingsFile;
      force = true;
    };

    services.glance = {
      enable = true;
      settings = cfg.settings;
    };

    launchd.agents.glance = {
      enable = true;
      config = {
        inherit Label;
        RunAtLoad = true;
        KeepAlive = true;
        EnvironmentVariables = envVars;
        ProgramArguments = [
          (lib.getExe pkgs.glance)
          "--config"
          (toString settingsFile)
        ];
        StandardOutPath = "${log-dir}/out.log";
        StandardErrorPath = "${log-dir}/err.log";
      };
    };
  };
}
