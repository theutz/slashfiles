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

  EDITOR = lib.getExe pkgs.${namespace}.nvf;

  packages =
    with pkgs;
    [
      bashInteractive
      onefetch
      starship
      git
      watchexec
      nh
      gum
      just
      sops
      ssh-to-age
      overmind
    ]
    ++ (with pkgs.${namespace}; [
      nvf
    ]);

  shellHook =
    # bash
    ''
      onefetch
      gum format "# ${namespace}"
      eval $(starship init bash)
    '';
}
