export TERM="xterm-256color"

if
  run @tmux@ ls &>/dev/null
then
  verboseEcho "Reloading tmux..."
  if
    run @tmux@ source-file "@file@"
  then
    verboseEcho "Tmux config reloaded!"
  else
    echo "ERROR: Could not reload tmux config."
  fi
else
  verboseEcho "No tmux running"
fi
