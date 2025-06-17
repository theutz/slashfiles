{
  pkgs,
  namespace,
  lib,
  ...
}: let
  name = ./. |> builtins.dirOf |> builtins.baseNameOf;
  description = ''
    Open this repo as a tmux session
  '';
in
  pkgs.writeShellApplication {
    inherit name;

    meta = {
      inherit description;
    };

    runtimeInputs = with pkgs; [
      gum
      getopt
      tmux
      tmuxp
    ];

    runtimeEnv = {
      WORKSPACE = ../..;
      SESSION = namespace;
    };

    text =
      # bash
      ''
        if tmux has-session "$SESSION" &>/dev/null; then
          if [[ -v TMUX && -n "$TMUX" ]]; then
            tmux switch-client -t "$SESSION"
          else
            tmux attach -t "$SESSION"
          fi
        else
          tmuxp load --yes "$WORKSPACE"
        fi
      '';
  }
