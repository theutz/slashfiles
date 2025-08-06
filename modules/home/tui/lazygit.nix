{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkConfig;
in
{
  config = mkConfig {
    programs.lazygit.enable = true;
    home.shellAliases = {
      lg = "lazygit";
    };
  };
}
