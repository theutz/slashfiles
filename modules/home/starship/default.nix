{
  pkgs,
  lib,
  namespace,
  config,
  osConfig,
  ...
}: let
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};

  themes = {
    rose-pine = "rose-pine";
    rose-pine-dawn = "rose-pine-dawn";
    rose-pine-moon = "rose-pine-moon";
  };

  inherit (lib.${namespace}) prefs;
  inherit (prefs.theme) dark light main;

  mkRosePinePath = file:
    {
      owner = "rose-pine";
      repo = "starship";
      rev = "c6aeb2833e3d563ca3bbffcb4bad09d44bf817ec";
      hash = "sha256-oFHyel6nYOPdK9VbNp7KbKL/3WeBp/SFHzKTq/9Bhh8=";
    }
    |> pkgs.fetchFromGitHub
    |> lib.getAttr "outPath"
    |> (p: "${p}/${themes.${file}}.toml");

  script =
    pkgs.writeShellScript "update-starship"
    # bash
    ''
      set -euo pipefail
      file=""
      case "$1" in
        dark)
          file="${mkRosePinePath dark}"
          ;;
        light)
          file="${mkRosePinePath light}"
          ;;
        *)
          >&2 echo "Unknown mode: $1"
          exit 1
      esac

      ln -sf "$file" ~/.config/starship.toml
    '';

  withDarkNotify =
    lib.optionalAttrs cfg.enableDarkNotifyIntegration {
    };
in {
  options.${namespace}.${mod} = {
    enable = lib.mkEnableOption "enable ${mod}";
    enableDarkNotifyIntegration = lib.mkEnableOption "update appearance with system";
  };

  config = lib.mkIf cfg.enable {
    assertions = lib.optionals cfg.enableDarkNotifyIntegration [
      {
        assertion = pkgs.stdenv.isDarwin;
        message = "Dark notify integration is only available on Darwin systems.";
      }
    ];

    xdg.configFile."starship.toml" = {
      source =
        main
        |> mkRosePinePath;
      force = true;
    };

    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };

    home.packages = lib.optionals cfg.enableDarkNotifyIntegration [pkgs.dark-notify];

    home.activation.refreshStarship =
      lib.optionalAttrs cfg.enableDarkNotifyIntegration
      (config.lib.dag.entryAfter ["writeBoundary" "reloadTmux"]
        # bash
        ''
          verboseEcho "Dark-notify script at ${script}"
          ${lib.getExe pkgs.dark-notify} --exit -c "${script}"
        '');

    launchd.agents.starship-dark = let
      Label = "com.${namespace}.starship-dark";
    in {
      enable = true;
      config = {
        inherit Label;
        RunAtLoad = true;
        KeepAlive = true;
        ProgramArguments = [
          (lib.getExe pkgs.dark-notify)
          "-c"
          script.outPath
        ];
        StandardErrorPath = "/tmp/${Label}/err.log";
        StandardOutPath = "/tmp/${Label}/out.log";
      };
    };
  };
}
