{pkgs, ...}:
pkgs.writeShellApplication {
  name = "thome";

  meta.description = ''
    Connect to your home tmux session
  '';

  runtimeInputs = with pkgs; [
    tmux
  ];

  text =
    /*
    bash
    */
    ''
      session_name="home"

      {
        if
          ! tmux new -s "$session_name" -n main -A
        then
          tmux switch-client -t "$session_name"
        fi
      } >/dev/null 2>&1
    '';
}
