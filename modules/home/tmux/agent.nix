{
  lib,
  pkgs,
  osConfig,
  light,
  dark,
  ...
}: let
  tmux = lib.getExe pkgs.tmux;

  mkSetTmuxOpts = theme:
    theme
    |> lib.getAttr "defaults"
    |> lib.mapAttrsToList (n: v: ''${tmux} set-option -g ${n} "${v}"'')
    |> lib.concatLines;

  script =
    pkgs.writeShellScript "update-tmux"
    # bash
    ''
      MODE="$1"

      case "$MODE" in
        light)
          ${mkSetTmuxOpts light}
          ;;
        dark)
          ${mkSetTmuxOpts dark}
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
  config = {
    KeepAlive = true;
    RunAtLoad = true;
    StandardOutPath = "/tmp/org.nix-community.home/tmux-dark/out.log";
    StandardErrorPath = "/tmp/org.nix-community.home/tmux-dark/err.log";
    ProgramArguments = [
      "${osConfig.homebrew.brewPrefix}/dark-notify"
      "-c"
      script.outPath
    ];
  };
}
