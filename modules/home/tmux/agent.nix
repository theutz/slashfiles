{
  lib,
  pkgs,
  osConfig,
  light,
  dark,
  mkVariantOpt,
  ...
}: let
  tmux = lib.getExe pkgs.tmux;

  script =
    pkgs.writeShellScript "update-tmux"
    # bash
    ''
      MODE="$1"

      case "$MODE" in
        light)
          tmux set-option -g ${mkVariantOpt light}
          ;;
        dark)
          tmux set-option -g ${mkVariantOpt dark}
          ;;
        *)
          >&2 echo "Mode was not defined"
          exit 1
          ;;
      esac

      ${tmux} source-file ~/.config/tmux/tmux.conf
    '';
in {
  enable = true;
  config = rec {
    Label = "com.theutz.tmux-dark";
    KeepAlive = true;
    RunAtLoad = true;
    StandardOutPath = "/tmp/${Label}/out.log";
    StandardErrorPath = "/tmp/${Label}/err.log";
    ProgramArguments = [
      "${osConfig.homebrew.brewPrefix}/dark-notify"
      "-c"
      script.outPath
    ];
  };
}
