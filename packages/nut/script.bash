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

| Name          | Description                         | Default             | Current                               |
| :------------ | :---------------------------------- | :------------------ | :------------------------------------ |
| NUT_PATH      | The path where notes are saved.     | \@default-nut-path@ | ${NUT_PATH:-@default-nut-path@}       |
| NUT_LOG_LEVEL | Log level: debug, info, warn, error | @default-log-level@ | ${NUT_LOG_LEVEL:-@default-log-level@} |
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

function select_note() {
  if out="$(
    fd --base-directory="$NUT_PATH" --relative-path "${@:-.}" |
      fzf --preview "bat $NUT_PATH/{}" --accept-nth="$NUT_PATH/{1}"
  )"; then
    debug -s "Note selected" note "$out"
    echo "$out"
    return 0
  else
    code="$?"
    case "$code" in
    130)
      warn -s "User cancelled selection"
      return 130
      ;;
    *)
      error -s "Error while selecting note" code "$code"
      return 1
      ;;
    esac
  fi
}

function do_delete() {
  FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --multi"
  if notes="$(select_note .)"; then
    debug -s "Selected notes for deletion" notes "${notes[*]}"
    for note in $notes; do
      debug -s "Deleting" note "$note"
      rm -r "$note"
    done
  else
    error "Could not select notes"
    return 1
  fi
}

function do_edit() {
  if note="$(select_note .)"; then
    debug -s "Editing" note "$note"
  else
    code=$?
    error -s "Failed while selecting file" code "$code"
    return $code
  fi
  if "$NUT_EDITOR" "$note"; then
    debug "Note saved"
    return 0
  else
    code="$?"
    error -s "Failed while editing" code "$code"
    return "$code"
  fi
}

function init() {
  if [[ ! -v NUT_PATH || -z "$NUT_PATH" ]]; then
    export NUT_PATH="@default-nut-path@"
    info -s "NUT_PATH not set. Using default" path "$NUT_PATH"
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

  if [[ ! -v NUT_EDITOR || -z "$NUT_EDITOR" ]]; then
    default="${EDITOR:-vim}"
    info -s "NUT_EDITOR not set. Using default" default "$default"
    export NUT_EDITOR="$default"
  fi
}

function main() {
  export GUM_LOG_LEVEL="${NUT_LOG_LEVEL:-warn}"

  parsed="$(
    getopt \
      --longoptions='help,debug,verbose' \
      --options='+hdv' \
      --name="@name@" \
      -- "$@" 2>/dev/null
  )" || return 2
  eval set -- "$parsed"

  flag_help=n
  flag_debug=n
  flag_verbose=n
  args=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
    --help | -h) flag_help=y ;;
    --debug | -d) flag_debug=y ;;
    --verbose | -v) flag_verbose=y ;;
    --) ;;
    *)
      args+=("$1")
      ;;
    esac
    shift
  done
  debug -s -- "args after parsing" args "${args[*]}"
  set -- "${args[@]}"

  if [[ $flag_debug == y ]]; then
    set -x
    export GUM_LOG_LEVEL="debug"
    debug "Debug mode enabled"
  fi

  if [[ $flag_verbose = y ]]; then
    export GUM_LOG_LEVEL="debug"
    info "Verbose mode enabled"
  fi
  export GUM_LOG_LEVEL

  if [[ $flag_help == y ]]; then
    usage
    return 0
  fi

  init

  if [[ ! -v 1 ]]; then
    do_paste "$@" || return $?
    return 0
  fi
  while [[ $# -gt 0 ]]; do
    arg="$1"
    shift
    debug -s -- "parsing" arg "$arg"
    case "$arg" in
    paste | p)
      do_paste "$@" || return $?
      return
      ;;
    edit | e)
      do_edit "$@" || return $?
      return
      ;;
    delete | rm | x)
      do_delete "$@" || return $?
      return
      ;;
    --) shift ;;
    *)
      error -s "Unknown command" command "$arg"
      return 1
      ;;
    esac
  done
  error "Unknown condition"
  return 1
}

code=0
main "$@" || code="$?"
case "$code" in
0)
  log "Loves ya!"
  exit
  ;;
*)
  error "Awww, nuts!"
  exit 1
  ;;
esac
