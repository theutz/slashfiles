{
  pkgs,
  inputs',
  self',
  ...
}: let
  cmd =
    if pkgs.stdenv.isDarwin
    then "darwin"
    else "os";
  name = "swch";
  description = ''Run {nixos,darwin}-rebuild switch equivalent from anywhere.'';
in
  pkgs.writeShellApplication {
    inherit name;
    meta.description = description;

    runtimeInputs = [
      inputs'.nh.packages.default
      self'.packages.comt
      pkgs.git
      pkgs.gum
      pkgs.aichat
      pkgs.noti
    ];

    text =
      # bash
      ''
        trap 'noti -t "${name}" -m "Process complete"' EXIT

        debug=0
        help=0

        args=()
        while [[ $# -gt 0 ]]; do
          case "$1" in
            --verbose | -v)
              debug=1
              shift
              ;;
            --help | -h)
              help=1
              shift
              ;;
            *)
              args+=("$1")
              shift
              ;;
          esac
        done
        set -- "''${args[@]}"

        usage() {
          cat <<-markdown | gum format
        # ${name}

        ${description}

        ## Usage

        \```
        ${name} [flags]
        \```

        ## Flags

        -h, --help       Show this help
        -v, --verbose    Print verbose logs
        markdown
        }

        if [[ $help -eq 1 ]]; then
          usage
          exit 0
        fi

        log () {
          gum log --prefix ${name} "$@"
        }

        error () {
          log --level error "$@"
        }

        info () {
          log --level info "$@"
        }

        debug () {
          if [[ $debug -eq 1 ]]; then
            log --level debug "$@"
          fi
        }

        debug "Checking for flake environment var"
        if [[ ! -v NH_FLAKE || -z "$NH_FLAKE" ]]; then
          error "Please define an NH_FLAKE environment variable."
          exit 1
        else
          debug -s "Found" "NH_FLAKE" "$NH_FLAKE"
        fi

        debug "Adding all files in the flake's the git repository"
        if
          git -C "$NH_FLAKE" add --all
        then
          debug "Added successfully";
        else
          error "Could not add all files."
          exit 1
        fi

        debug "Running \`nh ${cmd} switch\`"
        if
          nh ${cmd} switch
        then
          info "Switch complete!"
        else
          error "Sorry. Could not switch."
          exit 1
        fi

        debug "Creating commit message"
        if
          comt -C "$NH_FLAKE" -a
        then
          info "Changes committed"
        else
          error "Could not commit changes."
          exit 1
        fi
      '';
  }
