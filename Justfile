_default:
  just --list

watch-nixos:
  watchexec \
    --watch nix/packages \
    --watch nix/modules/nixos \
    --watch nix/systems \
    --postpone \
    --restart \
    --notify \
    -- \
    nh os switch

watch-home:
  watchexec \
    --watch nix/packages \
    --watch nix/modules/home \
    --watch nix/homes \
    --postpone \
    --restart \
    --notify \
    -- \
    nh home switch
