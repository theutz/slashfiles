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
in {
  options.${namespace}.${mod} = {
    enable = lib.mkEnableOption "enable ${mod}";

    settings = lib.mkOption {
      inherit (settingsFormat) type;
      default = lib.${namespace}.fromYAML pkgs ./glance.yml;
      description = ''
        Configuration written to a yaml file that is read by glance. See
        <https://github.com/glanceapp/glance/blob/main/docs/configuration.md>
        for more.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      GLANCE_PORT_FILE = osConfig.sops.secrets."glance/port".path;
    };

    home.packages = with pkgs; [glance];

    xdg.configFile."glance/glance.yml".source = settingsFile;

    launchd.agents.glance = {
      enable = true;
      config = rec {
        Label = "com.${namespace}.${mod}";
        RunAtLoad = true;
        KeepAlive = true;
        ProgramArguments = [
          (lib.getExe pkgs.glance)
          "--config"
          (toString settingsFile)
        ];
        StandardOutPath = "/tmp/${Label}/out.log";
        StandardErrorPath = "/tmp/${Label}/err.log";
      };
    };
  };
}
