{
  namespace,
  lib,
  config,
  pkgs,
  ...
}: let
  mod = baseNameOf ./.;
  cfg = config |> lib.getAttrFromPath [namespace mod];
in {
  options.${namespace}.${mod} = {
    # https://github.com/ttytm/wthrr-the-weathercrab
    enable = lib.mkEnableOption "enable wthrr - the weather crab";

    address = lib.mkOption {
      type = with lib.types; uniq str;
      default = "Golcuk, Kocaeli, TR";
      description = ''
        Address to check the weather, e.g.: "Berlin,DE"
      '';
    };

    language = lib.mkOption {
      type = with lib.types; uniq str;
      description = ''
        Language code of the output language
      '';
      default = "en_US";
    };

    forecast = lib.mkOption {
      type = with lib.types;
        uniq (listOf (enum [
          "week"
          "day"
          "today"
          "tomorrow"
          "mo"
          "tu"
          "we"
          "th"
          "fr"
          "sa"
          "su"
          "disable"
        ]));
      description = ''
        Forecast to display without adding the `-f` option: `[day]` | `[week]` | `[day, week]`
      '';
      default = ["day" "week"];
    };

    temperature = lib.mkOption {
      type = with lib.types; uniq (enum ["celsius" "fahrenheit"]);
      description = ''
        Temperature units
      '';
      default = "celsius";
    };

    windspeed = lib.mkOption {
      type = with lib.types; uniq (enum ["kmh" "mph" "knots" "ms"]);
      default = "kmh";
      description = "(Wind)speed units";
    };

    time = lib.mkOption {
      type = with lib.types; uniq (enum ["military" "am_pm"]);
      description = ''
        Time units
      '';
      default = "military";
    };

    precipitation = lib.mkOption {
      type = with lib.types; uniq (enum ["probability" "mm" "inch"]);
      default = "probability";
      description = ''
        Precipitation units
      '';
    };

    greeting = lib.mkOption {
      type = with lib.types; uniq bool;
      default = false;
      description = ''
        Display greeting message
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [wthrr];

    home.file."Library/Application Support/weathercrab/wthrr.ron" = {
      text = ''
        (
            address: "${cfg.address}",
            language: "${cfg.language}",
            forecast: [${cfg.forecast |> lib.concatStringsSep ", "}],
            units: (
                temperature: ${cfg.temperature},
                speed: ${cfg.windspeed},
                time: ${cfg.time},
                precipitation: ${cfg.precipitation},
            ),
            gui: (
                border: rounded,
                color: default,
                graph: (
                    style: lines(solid),
                    rowspan: double,
                    time_indicator: true,
                ),
                greeting: ${cfg.greeting |> lib.boolToString},
            ),
        )
      '';
    };
  };
}
