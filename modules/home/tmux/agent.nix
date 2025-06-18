{
  lib,
  pkgs,
  osConfig,
  light,
  mkVariantOpt,
  ...
}: let
  tmux = lib.getExe pkgs.tmux;

  script =
    pkgs.writeShellScript "update-tmux"
    # bash
    ''
      MODE="$1"
      cmd=("${tmux}" set-option -g)

      case "$MODE" in
        light)
          cmd+=(${mkVariantOpt light})
          ;;
        dark)
          cmd+=(${mkVariantOpt light})
          ;;
        *)
          >&2 echo "Mode was not defined"
          exit 1
          ;;
      esac

      ''${cmd[@]} \; source-file ~/.config/tmux/tmux.conf
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
