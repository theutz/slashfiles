{pkgs, ...}: let
  name = "thome";
  description = ''
    Connect to your home tmux session
  '';
  session_name = "home";
  config_file = pkgs.replaceVars ./tmuxp.yaml {
    inherit session_name;
  };
in
  pkgs.writeShellApplication {
    inherit name;

    meta = {
      inherit description;
    };

    runtimeInputs = with pkgs; [
      tmux
      tmuxp
      gum
      getopt
    ];

    text =
      # bash
      ''
        log() {
          gum log --prefix "${name}" "$@"
        }

        error() {
          log --level error "$@"
        }

        info() {
          log --level info "$@"
        }

        parsed="$(getopt \
          --longoptions=debug,help,kill,verbose \
          --options=dhkv \
          --name="${name}" -- "$@")" ||
          exit 2
        eval set -- "$parsed"

        flag_debug=n flag_help=n flag_kill=n flag_verbose=n

        usage() {
          cat <<-markdown | gum format
        # ${name} [flags]

        ${description}

        ## FLAGS

        -d, --debug       Show debug output
        -h, --help        Show this help
        -k, --kill        Kill and restart
        -v, --verbose     Show verbose output
        markdown
        }

        while :; do
          case "$1" in
            --debug | -d) flag_debug=y ;;
            --help | -h) flag_help=y ;;
            --kill | -k) flag_kill=y ;;
            --verbose | -v) flag_verbose=y ;;
            --) shift; break ;;
            *) error "Programming error" ;;
          esac
          shift
        done

        [[ $flag_debug == y ]] && { set -x; flag_verbose=y; }
        if [[ $flag_verbose == y ]]; then exec 3>&1; else exec 3>/dev/null; fi
        [[ $flag_help == y ]] && { usage; exit 0; }

        if tmux has-session -t "${session_name}" 2>&3 1>&3; then
          info "Session exists"

          if [[ $flag_kill == y ]]; then
            if [[ -v TMUX && -n "$TMUX" ]]; then
              info "Switching client"
              tmux switch-client -t "${session_name}"
            else
              info "Attaching client"
              tmux attach -t "${session_name}"
            fi
          else
            info "Killing session"
            tmux kill-session -t "${session_name}"
          fi
        fi

        info "Loading session file"
        tmuxp load --yes ${config_file} 2>&3 1>&3
      '';
  }
