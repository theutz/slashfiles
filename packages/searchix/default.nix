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

        > ${name} [flag] \<query\>

        ${description}

        Flags are mutually exclusive.

        ## FLAGS

        -d, --darwin     Search nix-darwin options
        -h, --help       Show this help
        -m, --hm         Search Home Manager related options
        -n, --nixos      Search NixOS options
        -p, --nixpkgs    Search nixpkgs
        -u, --nur        Search nix user repository
        markdown
        }

        log() {
          gum log --prefix "${name}" "$@"
        }

        error() {
          log --level error "$@"
        }

        do_help=0
        category="/"
        args=()

        while [[ $# -gt 0 ]]; do
          case "$1" in
            --help | -h)
              do_help=1;;
            --darwin | -d)
              category="/options/darwin/search";;
            --hm | -m)
              category="/options/home-manager/search";;
            --nixos | -n)
              category="/options/nixos/search";;
            --nixpkgs | -p)
              category="/packages/nixpkgs/search";;
            --nur | -u)
              category="/packages/nur/search";;
            *)
              args+=("$1");;
          esac
          shift
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

        xhs "searchix.ovh''${category}" page==0 query=="''$*" |
          html2markdown \
            --plugin-table \
            --opt-table-newline-behavior=preserve \
            --include-selector '#results table' |
          gum format |
          less -SR
      '';
  }
