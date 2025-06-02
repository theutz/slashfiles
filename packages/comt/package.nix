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
        repo=""
        do_add_all=0

        while [[ $# -gt 0 ]]; do
          case "$1" in
            -C)
              repo="$2"
              shift 2
              ;;
            --all | -a)
              do_add_all=1
              shift
              ;;
            *)
              args+=("$1")
              shift
              ;;
          esac
        done

        set -- "''${args[@]}"

        git="git ''${repo:+-C ''${repo}}"

        if [[ $do_add_all -eq 1 ]]; then
          $git add --all
        else
          $git add --interactive
        fi

        file="''${repo:+''${repo}/}.git/comt_msg"

        msg="$($git diff --cached | aichat "$PROMPT")"

        if [[ -z "$msg" ]]; then
          echo "No commit message generated" >&2
          $git commit "$@"
        else
          echo "$msg" > "$file"
          $git commit --file "$msg" --edit "$@"
        fi
      '';
  }
