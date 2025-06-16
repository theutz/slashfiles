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
    ];

    text =
      /*
      bash
      */
      ''
        do_help=0
        do_kill=0

        usage() {
          cat <<-markdown | gum format
        # ${name} [flags]

        ${description}

        ## FLAGS

        -h, --help        Show this help
        -k, --kill        Kill and restart
        markdown
        }

        log() {
          gum log --prefix "${name}" "$@"
        }

        error() {
          log --level error "$@"
        }

        info() {
          log --level info "$@"
        }

        _tmux() {
          &>/dev/null tmux "$@"
        }

        args=()
        while [[ $# -gt 0 ]]; do
          case "$1" in
            --kill | -k)
              do_kill=1
              shift
              ;;
            --help | -h)
              do_help=1
              shift
              ;;
            --* | -*)
              error -s "Unknown arg" arg "$1"
              exit 1
              ;;
            *)
              args+=("$1")
              shift
              ;;
          esac
        done
        set -- "''${args[@]}"

        if [[ $do_help -eq 1 ]]; then
          usage
          exit 0
        fi

        if _tmux has-session -t "${session_name}"; then
          info "Session exists"

          if [[ $do_kill -eq 0 ]]; then
            if [[ -v TMUX && -n "$TMUX" ]]; then
              info "Switching client"
              _tmux switch-client -t "${session_name}"
            else
              info "Attaching client"
              _tmux attach -t "${session_name}"
            fi
          else
            info "Killing session"
            _tmux kill-session -t "${session_name}"
          fi
        fi

        info "Loading session file"
        &>/dev/null tmuxp load --yes ${config_file}
      '';
  }
