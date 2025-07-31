{
  pkgs,
  lib,
  mkShell,
  namespace,
  ...
}:
mkShell {
  name = namespace;
  meta.description = "dotfiles everywhere";

  EDITOR = lib.getExe pkgs.slashfiles.nvf;

  packages = with pkgs; [
    onefetch
    git
    watchexec
    nh
    slashfiles.nvf
    gum
  ];

  shellHook =
    # bash
    ''
      gum format "# ${namespace}"
      echo
    '';
}
