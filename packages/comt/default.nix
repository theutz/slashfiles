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
        do_commit=1
        edit_message=0

        while [[ $# -gt 0 ]]; do
          case "$1" in
            --edit-message | -m)
              edit_message=1
              shift
              ;;
            --no-commit | --echo | -e)
              do_commit=0
              shift
              ;;
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
          # ${name} [flags]

          ${description}

          ## FLAGS

          -C, --working-directory    Change the working directory for the git commands
          -m, --edit-message         Edit the message in EDITOR before committing
          -e, --no-commit, --echo    Echo the commit message without committing
          -h, --help                 Show this help
          -i, --interactive          Interactively add files instead of adding everything

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

        msg="$(
          gum spin --show-output --title "Generating commit message..." -- \
            bash -c "$git diff --cached | aichat \"$PROMPT\""
        )"

        if [[ -z "$msg" ]]; then
          echo "No commit message generated" >&2
          exit 1
        fi

        if [[ $do_commit -eq 0 ]]; then
          echo "$msg"
          exit 0
        fi

        if [[ $edit_message -eq 1 ]]; then
          echo "$msg" > "$file"
          $git commit --file "$file" --edit "$@"
        else
          $git commit --file "$file" "$@"
        fi
      '';
  }
