{
  pkgs,
  lib,
  ...
}: let
  name = baseNameOf ./.;
  description = "Save stuff away for the future";
  longDescription = ''
    Save markdown files easily, automatically, and fun-ly.
  '';
in
  pkgs.writeShellApplication {
    inherit name;
    meta = {inherit description longDescription;};

    runtimeInputs = with pkgs; [
      gum
      getopt
    ];

    text =
      {
        inherit name longDescription;
      }
      |> pkgs.replaceVars ./script.bash
      |> lib.fileContents;
  }
