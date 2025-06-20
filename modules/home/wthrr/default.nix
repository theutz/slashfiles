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
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [wthrr];

    home.file."Application Support/weathercrab/wthrr.ron" = {
      text = ''
        (
            address: "${cfg.address}",
            language: "${cfg.language}",
            forecast: [
              ${cfg.forecast |> lib.concatStringsSep ",\n"}
            ],
            units: (
                temperature: celsius,
                speed: kmh,
                time: military,
                precipitation: probability,
            ),
            gui: (
                border: rounded,
                color: default,
                graph: (
                    style: lines(solid),
                    rowspan: double,
                    time_indicator: true,
                ),
                greeting: true,
            ),
        )
      '';
    };
  };
}
