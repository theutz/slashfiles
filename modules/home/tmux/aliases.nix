{lib, ...}: let
  # aliases = lib.pipe (import ./aliases.nix) [
  #   (lib.attrsets.mapAttrs
  #     (name: value: {inherit name value;}))
  #   lib.attrsets.attrValues
  #   (lib.imap
  #     (i: v: ''
  #       set -g command-alias[${builtins.toString (100 + i)}] ${v.name}="${v.value}"
  #     ''))
  #   lib.strings.concatLines
  # ];
in (
  {
    btop = "popup -EE -h90% -w95% -xC -yC -b heavy 'btop'";
    exit-node = "popup -h100% -w50% -xC -yC 'exit-node'";
    h = "split-window -v";
    man = "split-window -h -f -l 80 man";
    pause = "send -t spotify:main.1 ' '";
    play = "send -t spotify:main.1 ' '";
    reload = "source $HOME/.config/tmux/tmux.conf";
    restore = ''run-shell $HOME/.config/tmux/plugins/tmux-resurrect/scripts/restore.sh'';
    rp = "select-pane -T";
    rs = "rename-session";
    rw = "rename-window";
    s = "new-session";
    save = ''run-shell $HOME/.config/tmux/plugins/tmux-resurrect/scripts/save.sh'';
    spotify = "popup -EE -h80% -w90% -xC -yC -b heavy spotify_player";
    tz = ''popup -EE -xC -yC -b rounded -w100 -h20 -s "bg=colour8" tz'';
    v = "split-window -h";
    vol = "popup -xC -yS -w100 -h5 -b rounded -EE volgo";
    w = "new-window";
    x = "resize-pane -x";
    y = "resize-pane -y";
  }
  |> (lib.attrsets.mapAttrs (name: value: {inherit name value;}))
  |> lib.attrsets.attrValues
  |> lib.imap (i: v: ''
    set -g command-alias[${builtins.toString (100 + 1)}] ${v.name}="${v.value}"
  '')
  |> lib.strings.concatLines
  |> lib.attrsets.setAttrByPath ["config" "programs" "tmux" "extraConfig"]
)
