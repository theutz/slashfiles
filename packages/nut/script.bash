function log() {
  gum log --prefix "@name@" "$@"
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

function usage() {
  cat <<-markdown | gum format
# @name@

@longDescription@

## USAGE

> @name@ [FLAGS]

## FLAGS

-d, --debug       Enable debugging output
-h, --help        Show this help
-v, --verbose     Enable verbose output
markdown
}

function main() {
  parsed="$(
    getopt \
      --longoptions=help,debug,verbose \
      --options hdv \
      --name "@name" \
      -- "$@"
  )" || exit 2
  eval set -- "$parsed"

  flag_help=n
  flag_debug=n
  flag_verbose=n

  while [[ $# -gt 0 ]]; do
    case "$1" in
    --help | -h) flag_help=y ;;
    --debug | -d) flag_debug=y ;;
    --verbose | -v) flag_verbose=y ;;
    --)
      shift
      break
      ;;
    *)
      error -s "Error parsing args" arg "$1"
      exit 1
      ;;
    esac
    shift
  done

  if [[ $flag_debug == y ]]; then
    set -x
    flag_verbose=y
    debug "Debug mode enabled"
  fi

  if [[ $flag_verbose = y ]]; then
    debug "Verbose mode enabled"
    exec 3>&1
  else
    exec 3>/dev/null
  fi

  if [[ $flag_help == y ]]; then
    usage
    exit 0
  fi
}

main "$@"
