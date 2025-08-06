{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.mkMod config ./.) mkConfig;
in
{
  config = mkConfig {
    programs.direnv.enable = true;
    programs.direnv.mise.enable = true;
    programs.direnv.nix-direnv.enable = true;
  };
}
