{
  lib,
  namespace,
  config,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkMod;
in
mkMod {
  home.sessionVariables.DIRENV_LOG_FORMAT = "";

  programs.direnv.enable = true;
  programs.direnv.mise.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
