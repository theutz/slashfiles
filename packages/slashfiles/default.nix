{
  pkgs,
  namespace,
  ...
}: let
  name = ./. |> builtins.baseNameOf;
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
      WORKSPACE = "/etc/nix-darwin";
      SESSION = namespace;
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

        -d, --debug      Enable debug logging
        -h, --help       Show this help
        -k, --kill       Kill session if it exists and restart
        -v, --verbose    Enable verbose logging
        markdown
        }

        function log() {
          cmd=("gum" "log" "--prefix=${name}" "--min-level")
          if [[ $flag_verbose == y ]]; then
            cmd+=("debug")
          else
            cmd+=("info")
          fi
          cmd+=("$@")

          "''${cmd[@]}"
        }

        function debug() {
          log --level debug "$@"
        }

        function info() {
          log --level info "$@"
        }

        function error() {
          log --level error "$@"
        }

        parsed="$(getopt \
          --longoptions help,debug,verbose,kill \
          --options hdvk \
          --name "${name}" \
          -- "$@"
        )" || exit 2
        eval set -- "$parsed"

        flag_verbose=n flag_debug=n flag_help=n flag_kill=n
        while [[ $# -gt 0 ]]; do
          case "$1" in
            --help | -h) flag_help=y;;
            --debug | -d) flag_debug=y;;
            --verbose | -v) flag_verbose=y;;
            --kill | -k) flag_kill=y;;
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

        has_session="$(if tmux has-session -t "$SESSION" &>/dev/null; then echo y; else echo n; fi)"

        if [[ $flag_kill == y && $has_session == y ]]; then
          tmux kill-session -t "$SESSION" 2>&3 1>&3
        fi

        if [[ $has_session == y ]]; then
          debug "Session exists"
          if [[ -v TMUX && -n "$TMUX" ]]; then
            info "Switching to session..."
            tmux switch-client -t "$SESSION" 2>&3 1>&3
          else
            info "Attaching to session"
            tmux attach -t "$SESSION" 2>&3 1>&3
          fi
        else
          info "Loading session"
          tmuxp load --yes "$WORKSPACE" 2>&3 1>&3
        fi
      '';
  }
