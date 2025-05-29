# /slashfiles

## test

> Run tests on the flake

```bash
nix flake check
```

### watch

> Watch for changes and run the tests

```bash
watchexec --restart -- nix flake check
```

## commit

> Commit changes automagically

**OPTIONS**
* all
  * flags: -a, --all
  * type: boolean
  * desc: stage all files before commit

```bash
prompt="$(cat <<-EOF
Create a conventional commit message for these changes.
Strip all leading and trailing whitespace.
Do not wrap the message in backticks.
EOF
)";
git diff --cached |
  aichat "$prompt" |
  git commit "${ALL:---all}" --file -
```
