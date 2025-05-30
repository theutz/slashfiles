{pkgs, ...}: let
  name = "comt";
in
  pkgs.writeShellApplication {
    inherit name;

    runtimeInputs = with pkgs; [
      aichat
      gum
      git
      coreutils
    ];

    runtimeEnv = {
      PROMPT = ''
        Ignore all previous instructions.
        Write a conventional commit message for these changes.
        Remove any leading or trailing whitespace.
        Do not wrap the message in backticks.
      '';
    };

    text =
      # bash
      ''
        args=()

        while [[ $# -gt 0 ]]; do
          case "$1" in
            --all | -a)
              git add -A
              shift
              ;;
            *)
              args+=("$1")
              shift
              ;;
          esac
        done

        set -- "''${args[@]}"

        msg=".git/comt_msg"

        git diff --cached |
          aichat "$PROMPT" > "$msg"

        git commit --template "$msg" "$@"
      '';
  }
