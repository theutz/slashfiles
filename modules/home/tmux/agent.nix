{
  lib,
  pkgs,
  light,
  dark,
  namespace,
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
          cmd+=(${mkVariantOpt dark})
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
      (lib.getExe pkgs.dark-notify)
      "-c"
      script.outPath
    ];
  };
}
