{
  lib,
  pkgs,
  ...
}:
let
  name = ./. |> builtins.baseNameOf;
  description = ''
    open any defined tmuxp sessions
  '';
  search_paths = [
    "$HOME"
    "/etc"
  ];
in
pkgs.writeShellApplication {
  inherit name;

  meta = { inherit description; };

  runtimeInputs = with pkgs; [
    gum
    getopt
    tmuxp
    fd
    fzf
    yq
  ];

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

      -d, --debug       Enable debug logging
      -e, --edit        Edit the file instead of loading it
      -h, --help        Show this help
      -v, --verbose     Enable verbose logging
      markdown
      }

      function log() {
        cmd=(gum log --prefix "${name}" --min-level)
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

      function warn() {
        log --level warn "$@"
      }

      function error() {
        log --level error "$@"
      }

      function fatal() {
        log --level fatal "$@"
      }

      parsed="$(getopt \
        --longoptions=help,debug,verbose,edit \
        --options=hdve \
        --name "${name}" \
        -- "$@"
      )" || exit 2
      eval set -- "$parsed"

      flag_help=n flag_verbose=n flag_debug=n flag_do_edit=n
      while [[ $# -gt 0 ]]; do
        case "$1" in
          --help | -h) flag_help=y;;
          --verbose | -v) flag_verbose=y;;
          --debug | -d) flag_debug=y;;
          --edit | -e) flag_do_edit=y;;
          --) shift; break;;
          *) error "Programming error"; exit 1;;
        esac
        shift
      done

      if [[ $flag_debug == y ]]; then
        debug "Debug mode enabled"
        set -x
        flag_verbose=y
      fi

      if [[ $flag_verbose == y ]]; then
        debug "Verbose logging enabled"
        exec 3>&1
      else
        exec 3>/dev/null
      fi

      if [[ $flag_help == y ]]; then
        usage
        exit 0
      fi

      ${lib.toShellVars { inherit search_paths; } |> lib.replaceStrings [ "'" ] [ ''"'' ]}

      session="$(fd --extension yaml --extension yml --hidden tmuxp "''${search_paths[@]}" | fzf)"
      session_name="$(yq -r .session_name "$session")"
      info -s "Selected session" path "$session" name "$session_name"

      if [[ $flag_do_edit == y ]]; then
        if "''${EDITOR:-nvim}" "$session"; then
          info "Session edited"
        else
          code=$?
          warn -s "Editor did not close properly" code $code
          fatal "Exiting"
          exit 1
        fi
      fi

      info -s "Loading..." session "$session"
      tmuxp load --yes "$session"
    '';
}
