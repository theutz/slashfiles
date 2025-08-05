_default:
  just --list

watch:
  overmind start

watch-nixos:
  watchexec \
    --wrap-process=none \
    --watch nix/overlays \
    --watch nix/packages \
    --watch nix/systems \
    --watch flake.nix \
    --postpone \
    --restart \
    --notify \
    -- \
    nh os switch

watch-home:
  watchexec \
    --watch nix/packages \
    --watch nix/overlays \
    --watch nix/modules/home \
    --watch nix/homes \
    --watch flake.nix \
    --postpone \
    --restart \
    --notify \
    -- \
    nh home switch
