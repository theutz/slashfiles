{
  pkgs,
  lib,
  namespace,
  config,
  osConfig,
  ...
}:
lib.slashfiles.mkModule {
  inherit config;
  here = ./.;
} {
  config = let
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
  in {
    launchd.agents.starship-dark = let
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
      enable = true;
      config = rec {
        Label = "com.theutz.starship-dark";
        RunAtLoad = true;
        StayAlive = true;
        ProgramArguments = [
          "${osConfig.homebrew.brewPrefix}/dark-notify"
          "-c"
          script.outPath
        ];
        StandardErrorPath = "/tmp/${Label}/err.log";
        StandardOutPath = "/tmp/${Label}/out.log";
      };
    };

    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;

      settings =
        main
        |> mkRosePinePath
        |> lib.fileContents
        |> builtins.fromTOML;
    };
  };
}
