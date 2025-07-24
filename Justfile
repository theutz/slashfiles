default:
  just --list

watch:
  watchexec --restart \
    --clear \
    --watch systems \
    --watch modules \
    --watch packages \
    -- nh os switch
