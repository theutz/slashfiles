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

~~~
@name@ [GLOBAL FLAGS] [command]
~~~

## GLOBAL FLAGS

- -d, --debug       _Enable debugging output_
- -h, --help        _Show this help_
- -v, --verbose     _Enable verbose output_

## COMMANDS

### paste (this is the default command)

paste from clipboard into a new note

## ENVIRONMENT VARIABLES

| Name     | Description                     | Default             | Current                          |
| :------- | :------------------------------ | :------------------ | :------------------------------- |
| NUT_PATH | The path where notes are saved. | \@default-nut-path@ | ${NUT_PATH:-@default-nut-path@} |
markdown
}

function do_paste() {
  paste_cmd=()
  if out="$(command -v pbpaste)"; then
    debug "Using pbpaste for clipboard" path "$out"
    paste_cmd=(pbpaste)
  elif out="$(command -v xclip)"; then
    debug -s "Using xclip for clipboard" path "$out"
    paste_cmd=(xclip -o -selection clipboard)
  fi

  content="$("${paste_cmd[@]}")"
  debug -f -- "Captured clipboard:\\n%s" "${content}"

  proompt="Ignore all previous instructions.
  Generate a filename for this content in kebab case.
  Output only the file name and extension."
  debug -s "Proompting for title" prompt "$proompt"

  title="$(aichat "$proompt" <<<"$content")"
  debug -s "Generated ai title" title "$title"
  title="$(date +%s)-${title}"
  debug -s "Prepended date stamp"

  if gum write --header="$title" --value="$content" >"$NUT_PATH/$title"; then
    cmd=(git -C "$NUT_PATH")
    if out="$(
      "${cmd[@]}" add -A
      "${cmd[@]}" commit -m "added $title"
    )"; then
      out="$("${cmd[@]}" show HEAD --summary --oneline)"
      debug -s "" git "$out"
    else
      error -s "Could not commit" details "$out"
    fi
  fi
}

function init() {
  if [[ ! -v NUT_PATH || -z "$NUT_PATH" ]]; then
    export NUT_PATH="@default-nut-path@"
    debug -s "NUT_PATH not set. Using default" path "$NUT_PATH"
  fi

  if [[ ! -d "$NUT_PATH" ]]; then
    warn -s "$NUT_PATH didn't exist. Creating..."
    mkdir -p "$NUT_PATH"
    info "$NUT_PATH created"
  fi

  if [[ ! -d "$NUT_PATH/.git" ]]; then
    warn "$NUT_PATH is not a git repo. Initializing..."
    if ! out=$(git -C "$NUT_PATH" init 2>&1); then
      error -s "Could not initialize git repo" details "$out"
    fi
  fi
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
    return 0
  fi

  init

  if [[ ! -v 1 ]]; then
    do_paste "$@"
    return
  fi
  case "$1" in
  paste) do_paste "$@" ;;
  *)
    error -s "Unknown command" command "$1"
    return 1
    ;;
  esac
}

main "$@"
