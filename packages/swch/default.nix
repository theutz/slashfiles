{
  pkgs,
  stdenv,
  namespace,
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

    runtimeInputs = with pkgs; [
      pkgs.${namespace}.comt
      nh
      git
      gum
      noti
      faketty
      lolcat
      figlet
    ];

    runtimeEnv = {
    };

    text =
      # bash
      ''
        trap 'noti -t "${name}" -m "Process complete"' EXIT

        debug=0
        help=0
        do_add_all=1

        args=()
        while [[ $# -gt 0 ]]; do
          case "$1" in
            --interactive | -i)
              do_add_all=0
              shift
              ;;
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

        -i, --interactive    "git add" files interactively
        -h, --help           Show this help
        -v, --verbose        Print verbose logs
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

        git="git -C $NH_FLAKE"

        debug "Checking for flake environment var"
        if [[ ! -v NH_FLAKE || -z "$NH_FLAKE" ]]; then
          error "Please define an NH_FLAKE environment variable."
          exit 1
        else
          debug -s "Found" "NH_FLAKE" "$NH_FLAKE"
        fi

        debug "Checking which files to add"
        if [[ $do_add_all -eq 1 ]]; then
          if $git add --all; then
            info "Added all files successfully";
          else
            error "Could not add all files."
          fi
        else
          if $git add --interactive; then
            info "Added files successfully";
          else
            error "Could not add all files."
            exit 1
          fi
        fi

        debug "Running checks"
        (
          cd "$NH_FLAKE"
          if output="$(gum spin --title "Formatting..." --show-output -- bash -c "faketty nix fmt 2>&1")"; then
            info "Files formatted"
          else
            error "Could not format."
            gum style --trim --no-strip-ansi "$output"
            exit 1
          fi

          if output="$(gum spin --title "Checking..." --show-output -- bash -c "faketty nix flake check 2>&1")"; then
            info "Flake checks passed"
          else
            error "Flake checks failed"
            gum style --margin="1 2" --trim --no-strip-ansi "$output"
            exit 1
          fi
        )

        info "Running \`nh ${cmd} switch\`"
        if
          nh ${cmd} switch
        then
          info "Switch complete!"
        else
          error "Sorry. Could not switch."
          exit 1
        fi

        info "Creating commit message"
        if
          comt -C "$NH_FLAKE"
        then
          info "Changes committed"
        else
          error "Could not commit changes."
          exit 1
        fi

        figlet -f nvscript "Done" |
          sed '/^\s*$/d' |
          lolcat --animate --speed 300
      '';
  }
