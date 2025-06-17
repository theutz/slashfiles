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
    ];

    text =
      # bash
      ''
        function usage() {
          cat <<-markdown | gum format
        # ${name}

        ${description}

        All other flags and arguments are passed to 'swch'

        FLAGS
        -h, --help         Show this help
        -i, --immediate    Run on first invocation
        markdown
        }

        parsed="$(getopt \
          --longoptions help,immediate \
          --options hi \
          --name "${name}" \
          -- "$@"
        )" || exit 2
        eval set -- "$parsed"

        flag_help=n flag_immediate=n

        while [[ $# -gt 0 ]]; do
          case "$1" in
            --help | -h) flag_help=y;;
            --immediate | -i) flag_immediate=y;;
            --) shift; break;;
            *) error "Programming error"; exit 1;;
          esac
          shift
        done

        if [[ $flag_help == y ]]; then
          usage
          exit 0
        fi

        cmd=("watchexec" "--restart" "--wrap-process=none")
        [[ $flag_immediate != y ]] && cmd+=("--postpone")
        cmd+=("--" "swch" "$@")

        "''${cmd[@]}"
      '';
  }
