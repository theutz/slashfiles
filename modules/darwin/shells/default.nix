{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkOptions mkConfig;
in
{
  options = mkOptions { };
  config = mkConfig {
    programs.zsh.enable = true;
    programs.fish.enable = true;
    programs.bash.enable = true;
  };
}
