{
  kill = ''
    bind-key -N "Open kill menu" x \
      display-menu -T "Kill..." -x "#{popup_pane_left}" -y "#{popup_pane_bottom}" \
        server S {
          kill-server
        } ''' session s {
          kill-session
        } other-sessions C-s {
          kill-session -a
        } 'bells' b {
          kill-session -C
        } ''' window w {
          kill-window
        } other-windows C-w {
          kill-window -a
        } respawn-window W {
          respawn-window -k
        } ''' pane p {
          kill-pane
        } other-panes C-p {
          kill-pane -a
        } respawn-pane P {
          respawn-pane -k
        }
  '';
}
