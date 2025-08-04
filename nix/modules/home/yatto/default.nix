{
  config,
  lib,
  pkgs,
  ...
}: let
  mod = builtins.baseNameOf ./.;
  cfg = config.programs.${mod};

  settingsFormatter = pkgs.formats.toml {};
  settingsFile = settingsFormatter.generate "config.toml" cfg.settings;
in {
  options.programs.${mod} = {
    enable = lib.mkEnableOption "enable ${mod}";

    settings = lib.mkOption {
      inherit (settingsFormatter) type;
      description = ''
        Settings to be stored in configuration file as described
        at https://github.com/handlebargh/yatto?tab=readme-ov-file#configuration;
      '';
      default = {
        git.default_branch = "main";
        git.remote = {
          enable = false;
          name = "origin";
        };
        storage.path = config.xdg.dataHome + "/yatto";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      slashfiles.yatto
    ];

    xdg.configFile."yatto/config.toml" = {
      source = settingsFile;
      force = true;
    };
  };
}
