{
  pkgs,
  namespace,
  lib,
  ...
}: let
  name = ./. |> builtins.dirOf |> builtins.baseNameOf;
  description = ''
    Open this repo as a tmux session
  '';
in
  pkgs.writeShellApplication {
    inherit name;

    meta = {
      inherit description;
    };

    runtimeInputs = with pkgs; [
      gum
      getopt
      tmux
      tmuxp
    ];

    text =
      # bash
      ''
      '';
  }
