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
      onefetch
      git
      watchexec
      nh
      gum
      just
      sops
      ssh-to-age
    ]
    ++ (with pkgs.${namespace}; [
      nvf
    ]);

  shellHook =
    # bash
    ''
      gum format "# ${namespace}"
      echo
    '';
}
