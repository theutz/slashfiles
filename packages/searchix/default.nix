{
  pkgs,
  namespace,
  ...
}: let
  name = "searchix";
  description = "Search for things on searchix";
in
  pkgs.writeShellApplication {
    inherit name;

    meta = {
      inherit description;
    };

    runtimeInputs = with pkgs; [
      gum
      pkgs.${namespace}.html2markdown
      glow
      xh
    ];

    text =
      # bash
      ''
        usage() {
          cat <<-markdown | gum format
        # ${name}

        > ${name} [flags] \<query\>

        ${description}

        ## FLAGS

        -h, --help        Show this help
        markdown
        }

        log() {
          gum log --prefix "${name}" "$@"
        }

        error() {
          log --level error "$@"
        }

        do_help=0
        args=()

        while [[ $# -gt 0 ]]; do
          case "$1" in
            --help | -h)
              do_help=1
              shift
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

        if [[ $# -lt 1 ]]; then
          error "Please include a query argument"
          usage
          exit 1
        fi

        xhs "searchix.ovh/" query=="''$*" |
          html2markdown \
            --plugin-table \
            --opt-table-newline-behavior=preserve \
            --include-selector '#results table' |
          gum format |
          less -SR
      '';
  }
