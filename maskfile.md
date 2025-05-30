# /slashfiles

## dev

> Start development servers

```bash
mprocs --names test,switch \
  "$MASK test watch" \
  "$MASK switch watch"
```

## switch

> Run switch command

```bash
swch
```

### watch

> Watch for changes and switch

```bash
watchexec \
  --postpone \
  -w homes \
  -w hosts \
  -w modules \
  -w packages \
  --restart \
  -- $MASK switch
```

## test

> Run tests on the flake

```bash
nix flake check
```

### watch

> Watch for changes and run the tests

```bash
watchexec --postpone --restart \
  -- nix flake check
```
