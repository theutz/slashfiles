_default:
  just --list

fmt:
  nix fmt

test: fmt
  nix flake check --all-systems

build: test
  nh os build
  nh home build

install: build
  nh os swtich
  nh home switch

loop:
  #!/usr/bin/env zsh
  while true; do
    nvim
    lazygit
    nh home switch -b $(date +%s).bak
    read -q "continue?Restart?"
  done

watch:
  overmind start

watch-nixos:
  watchexec \
    --wrap-process=none \
    --watch overlays \
    --watch packages \
    --watch systems \
    --watch flake.nix \
    --postpone \
    --restart \
    --notify \
    -- \
    nh os switch

watch-home:
  watchexec \
    --watch packages \
    --watch overlays \
    --watch modules/home \
    --watch homes \
    --watch flake.nix \
    --postpone \
    --restart \
    --notify \
    -- \
    nh home switch

nvim:
  nom build .#nvf && result/bin/nvim

nvim-inspect:
  nom build .#nvf && result/bin/nvf-print-config | bat -l lua
