{pkgs, ...}: let
  name = "comt";
  description = "Generate AI commit message for files";
in
  pkgs.writeShellApplication {
    inherit name;

    meta = {inherit description;};

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
        do_add_all=1
        do_help=0

        while [[ $# -gt 0 ]]; do
          case "$1" in
            --help | -h)
              do_help=1
              shift
              ;;
            --working-directory | -C)
              repo="$2"
              shift 2
              ;;
            --interactive | -i)
              do_add_all=0
              shift
              ;;
            *)
              args+=("$1")
              shift
              ;;
          esac
        done

        set -- "''${args[@]}"

        function usage() {
          cat <<-markdown | gum format
          # ${name}

          ${description}

          ## FLAGS

          -h, --help                 Show this help
          -i, --interactive          Interactively add files instead of adding everything
          -C, --working-directory    Change the working directory for the git commands

        markdown
        }

        if [[ $do_help -eq 1 ]]; then
          usage
          exit 0
        fi

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
          $git commit --file "$file" --edit "$@"
        fi
      '';
  }
