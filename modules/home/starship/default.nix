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
    inherit (lib.${namespace}) prefs;
    dark = prefs.theme.dark.starship;
    light = prefs.theme.light.starship;

    mkRosePinePath = file:
      {
        owner = "rose-pine";
        repo = "starship";
        rev = "c6aeb2833e3d563ca3bbffcb4bad09d44bf817ec";
        hash = "sha256-oFHyel6nYOPdK9VbNp7KbKL/3WeBp/SFHzKTq/9Bhh8=";
      }
      |> pkgs.fetchFromGitHub
      |> lib.getAttr "outPath"
      |> (p: "${p}/${file}.toml");
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
        dark
        |> mkRosePinePath
        |> lib.fileContents
        |> builtins.fromTOML;
    };
  };
}
