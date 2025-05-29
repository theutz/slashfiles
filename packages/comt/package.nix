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
        msg=".git/comt_msg"
        # [[ -f "$msg" ]] && rm -f "$msg"

        # trap 'rm .git/comt_msg' EXIT

        git diff --cached |
          aichat "$PROMPT" > "$msg"

        cat "$msg"
      '';
  }
