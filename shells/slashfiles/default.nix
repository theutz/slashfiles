{
  pkgs,
  nvim,
  ...
}:
pkgs.mkShell {
  name = "slashfiles";

  buildInputs = with pkgs; [
    fish
    nvim
    mask
    watchexec
    onefetch
    lazygit
  ];

  shellHook =
    /*
    bash
    */
    ''
      alias build="mask switch"
      alias dev="mask dev"
      alias reload="exec nix develop"
      alias lg="lazygit"
      alias m="mask"
      alias d="dev"
      alias b="build"
      alias r="reload"

      onefetch
    '';
}
