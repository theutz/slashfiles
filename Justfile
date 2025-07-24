default:
  just --list

watch:
  watchexec --restart \
    --clear \
    --watch systems \
    --watch modules \
    --watch packages \
    -- nh os build

build:
  nh os build --out-link ./result \
    -- --option allow-import-from-derivation false
