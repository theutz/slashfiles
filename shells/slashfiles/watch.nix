{pkgs, ...}: let
  name = "watch";
  description = "Watcher for working on this flake";
in
  pkgs.writeShellApplication {
    inherit name;
    meta = {inherit description;};

    runtimeInputs = with pkgs; [
      watchexec
      gum
      pkgs.slashfiles.swch
      getopt
    ];

    text =
      # bash
      ''
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

        function error() {
          log --level error "$@"
        }

        function usage() {
          cat <<-markdown | gum format
        # ${name}

        ${description}

        ## USAGE

        > ${name} [flags]

        ## FLAGS

        -d, --debug        Enable debug logging
        -h, --help         Show this help
        -i, --immediate    Run on first invocation
        -v, --verbose      Enable verbose logging

        NOTE: All other flags and arguments are passed to 'swch'
        markdown
        }

        function run_cmd() {
          cmd=("watchexec" "--wrap-process=none")
          [[ $flag_immediate != y ]] && cmd+=("--postpone")
          cmd+=("--" "swch" "$@")

          "''${cmd[@]}" &
          PID=$!

          function cleanup() {
            debug -s "Killing" pid "$PID"
            kill "$PID" 2>/dev/null
            wait "$PID" 2>/dev/null
            info "Watch closed"
          }

          trap cleanup EXIT

          wait "$PID"
        }

        function main() {
          parsed="$(getopt \
            --longoptions=debug,help,immediate,verbose \
            --options=dhiv \
            --name "${name}" \
            -- "$@"
          )" || exit 2
          eval set -- "''$parsed"

          flag_help=n
          flag_immediate=n
          flag_verbose=n
          flag_debug=n

          while [[ $# -gt 0 ]]; do
            case "$1" in
              --debug | -d) flag_debug=y;;
              --help | -h) flag_help=y;;
              --immediate | -i) flag_immediate=y;;
              --verbose | -v) flag_verbose=y;;
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
            debug "Verbose mode enabled"
          else
            exec 3>/dev/null
          fi

          if [[ $flag_help == y ]]; then
            usage
            exit 0
          fi

          run_cmd "$@"
        }

        main "$@"
      '';
  }
