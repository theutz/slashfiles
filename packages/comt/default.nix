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
      getopt
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
        function usage() {
          cat <<-markdown | gum format
          # ${name}

          ${description}

          ## USAGE

          > ${name} [flags]

          ## FLAGS

          -d, --debug                Enable debug output
          -C, --working-directory    Change the working directory for the git commands
          -e, --echo                 Echo the commit message without committing
          -h, --help                 Show this help
          -i, --interactive          Interactively add files instead of adding everything
          -m, --edit-message         Edit the message in \$EDITOR before committing
          -v, --verbose              Enable verbose logging
        markdown
        }

        function log() {
          gum log --prefix "${name}" "$@"
        }

        function debug() {
          if [[ $flag_debug == y ]]; then
            log --level debug "$@"
          fi
        }

        function error() {
          log --level error "$@"
        }

        # do_add_all=1
        # do_help=0
        # do_commit=1
        # edit_message=0

        parsed="$(getopt \
          --longoptions='debug,working-directory,edit-message,interactive,help,verbose,echo' \
          --options='dC:mihve' \
          --name "${name}" \
          -- "$@"
        )" || exit 2
        eval set -- "''$parsed"

        opt_repo=""
        flag_debug=n
        flag_edit=n
        flag_help=n
        flag_interactive=n
        flag_verbose=n
        flag_echo=n

        while [[ $# -gt 0 ]]; do
          case "$1" in
            --debug | -d) flag_debug=y;;
            --edit-message | -m) flag_edit=y;;
            --help | -h) flag_help=y;;
            --interactive | -i) flag_interactive=y;;
            --verbose | -v) flag_verbose=y;;
            --working-directory | -C) opt_repo="$2"; shift;;
            --echo | -e) flag_echo=y;;
            --) shift; break;;
            *) error "Programming error"; exit 1;;
          esac
          shift
        done

        if [[ $flag_debug == y ]]; then
          set -x
          flag_verbose=y
          debug "Debug mode enabled"
        fi

        if [[ $flag_verbose == y ]]; then
          exec 3>&1
        else
          exec 3>/dev/null
        fi

        if [[ $flag_help == y ]]; then
          usage
          exit 0
        fi

        # while [[ $# -gt 0 ]]; do
        #   case "$1" in
        #     --debug)
        #       set -x
        #       shift
        #       ;;
        #     --edit-message | -m)
        #       edit_message=1
        #       shift
        #       ;;
        #     --no-commit | --echo | -e)
        #       do_commit=0
        #       shift
        #       ;;
        #     --help | -h)
        #       do_help=1
        #       shift
        #       ;;
        #     --working-directory | -C)
        #       opt_repo="$2"
        #       shift 2
        #       ;;
        #     --interactive | -i)
        #       do_add_all=0
        #       shift
        #       ;;
        #     *)
        #       args+=("$1")
        #       shift
        #       ;;
        #   esac
        # done
        # set -- "''${args[@]}"

        # Build git command from opts
        git=(git)
        [[ -n "$opt_repo" ]] && git+=(-C "$opt_repo")

        (
          flag="--all"
          if [[ $flag_interactive == y ]]; then
            flag="--interactive"
          fi
          "''${git[@]}" add "$flag"
        )

        file="''${opt_repo:+''${opt_repo}/}.git/comt_msg"

        msg="$(
          gum spin --show-output --title "Generating commit message..." -- \
            bash -c "''${git[*]} diff --cached | aichat \"$PROMPT\""
        )"

        if [[ -z "$msg" ]]; then
          error "No commit message generated"
          exit 1
        fi

        if [[ $flag_echo == y ]]; then
          echo "$msg"
          exit 0
        fi

        commit=("''${git[@]}" commit --no-verify --file "$file")

        echo "$msg" > "$file"


        if [[ $flag_edit == y ]]; then commit+=("--edit"); fi

        "''${commit[@]}" "$@"

        # if [[ $edit_message -eq 0 ]]; then
        #   "''${commit[@]}" "$@"
        # else
        #   "''${commit[@]}" --edit "$@"
        # fi
      '';
  }
