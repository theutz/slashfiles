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
in {
  options.${namespace}.${mod} = {
    enable = lib.mkEnableOption "enable ${mod}";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [dark-notify];

    home.activation.refreshStarship =
      config.lib.dag.entryAfter ["writeBoundary" "reloadTmux"]
      # bash
      ''
        verboseEcho "Dark-notify script at ${script}"
        ${lib.getExe pkgs.dark-notify} --exit -c "${script}"
      '';

    launchd.agents.starship-dark = {
      enable = true;
      config = rec {
        Label = "com.theutz.starship-dark";
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

    xdg.configFile."starship.toml" = {
      text =
        main
        |> mkRosePinePath
        |> lib.fileContents;
      force = true;
    };

    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };
  };
}
