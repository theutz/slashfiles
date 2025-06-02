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
      gitu
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

        if [[ $do_add_all -eq 1 ]]; then
          git ''${repo:+-C ''${repo}} add --all
        else
          (cd "$repo" && gitu)
        fi

        msg="''${repo:+''${repo}/}.git/comt_msg"

        git ''${repo:+-C ''${repo}} diff --cached |
          aichat "$PROMPT" > "$msg"

        git ''${repo:+-C ''${repo}} commit \
          --file "$msg" \
          --edit \
          "$@"
      '';
  }
