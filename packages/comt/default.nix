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
          if [[ $flag_verbose == y ]]; then
            log --level debug "$@"
          fi
        }

        function info() {
          log --level info "$@"
        }

        function warning() {
          log --level warning "$@"
        }

        function error() {
          log --level error "$@"
        }

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
          debug "Verbose mode enabled"
          exec 3>&1
        else
          exec 3>/dev/null
        fi

        if [[ $flag_help == y ]]; then
          usage
          exit 0
        fi

        # Build git command from opts
        git=(git)
        [[ -n "$opt_repo" ]] && git+=(-C "$opt_repo")

        # Add files according to options
        (
          cmd=("''${git[@]}" add)
          [[ $flag_verbose == y ]] && cmd+=("--verbose")
          if [[ $flag_interactive == y ]]; then
            cmd+=("--interactive")
          else
            cmd+=("--all")
          fi
          "''${cmd[@]}"
        )

        # Create commit message
        file="''${opt_repo:+''${opt_repo}/}.git/comt_msg"
        msg="$(
          gum spin --show-output --title "Generating commit message..." -- \
            bash -c "''${git[*]} diff --cached | aichat \"$PROMPT\""
        )"
        if [[ -z "$msg" ]]; then
          error "No commit message generated"
          exit 1
        fi

        # Route the output for the generated message
        if [[ $flag_echo == y ]]; then
          echo "$msg"
          exit 0
        else
          # To be consumed by git
          echo "$msg" > "$file"
        fi

        # Create commit
        (
          cmd=("''${git[@]}" commit --no-verify --file "$file")

          if [[ $flag_verbose != y ]]; then
            cmd+=("--quiet")
          fi

          # If the user wanted a chance to edit before committing...
          if [[ $flag_edit == y ]]; then
            cmd+=("--edit")
          fi

          # Run the command
          "''${cmd[@]}" "$@"
        )
      '';
  }
