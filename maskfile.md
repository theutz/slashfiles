# Tasks

## dev

> Watch for changes, and switch them!

```bash
watchexec --ignore result --wrap-process none -- mask switch
```

NOTE: By not wrapping the process, the terminal can attach to stdin for inputting passwords.

## switch

> Rebuild the user system

```bash
sudo darwin-rebuild switch
```

## reload

> Reload the devshell

```bash
exec nix develop
```
