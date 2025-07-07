{
  pkgs,
  config,
  namespace,
  lib,
  ...
}: let
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};
  settingsFormatter = pkgs.formats.toml {};
  settingsFile = settingsFormatter.generate "config.toml" cfg.settings;
in {
  options.${namespace}.${mod} = {
    enable = lib.mkEnableOption "enable ${mod}";

    settings = lib.mkOption {
      inherit (settingsFormatter) type;
      default = {
        notebook = {
          dir = "~/notes";
        };
        notes = {
          language = "en";
          default-title = "untitled";
          filename = "{{id}}-{{slug title}}";
          extension = "md";
          template = "default.md";
          id-charset = "alphanum";
          id-length = 4;
          id-case = "lower";
        };
      };
      description = ''
        TOML file with global settings for ZK.

        https://zk-org.github.io/zk/config/config.html
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [zk];

    xdg.configFile."zk/config.toml".source = settingsFile;
  };
}
