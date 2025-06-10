{
  pkgs,
  inputs,
  ...
}: let
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
    ];

    text =
      # bash
      ''
        usage() {
          cat <<-markdown | gum format
        # ${name}

        ${description}

        All other flags are passed to 'swch'

        FLAGS
        -h, --help         Show this help
        markdown
        }

        args=()
        while [[ $# -gt 0 ]]; do
          case "$1" in
            --help | -h)
              usage
              exit
              ;;
            *)
              args+=("$1")
              shift
              ;;
          esac
        done
        set -- "''${args[@]}"

        watchexec --restart --postpone --wrap-process=none -- swch "$@"
      '';
  }
