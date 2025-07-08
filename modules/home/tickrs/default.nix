{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: let
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};

  settingsFormatter = pkgs.formats.yaml {};
  settingsFile = settingsFormatter.generate "config.yml" cfg.settings;
in {
  options.${namespace}.${mod} = {
    enable = lib.mkEnableOption "enable ${mod}";

    settings = lib.mkOption {
      inherit (settingsFormatter) type;
      default = {
        symbols = [
          "USDTRY=X"
          "EURUSD=X"
          "EURTRY=X"
          "DJIA"
          "SPY"
        ];
        chart_type = "line";
        time_frame = "1W";
        show_x_labels = true;
      };
      description = ''
        Settings for tickrs. See <https://github.com/tarkah/tickrs/wiki/Config-file> for more details.
      '';
    };
  };

  config = lib.mkIf cfg.enable (lib.recursiveUpdate {
      home.packages = with pkgs; [tickrs];
    }
    (
      if pkgs.stdenv.isDarwin
      then {
        home.file."Library/Application Support/tickrs/config.yml" = {
          source = settingsFile;
          force = true;
        };
      }
      else {
        xdg.configFile."tickrs/config.yml" = {
          source = settingsFile;
          force = true;
        };
      }
    ));
}
