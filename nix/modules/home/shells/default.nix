{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.mkMod config ./.) mkConfig mkOptions;
in
{
  imports = lib.${namespace}.list-other-files ./.;

  options = mkOptions { };

  config = mkConfig {
    programs.starship.enable = true;
    programs.starship.settings = {
      shell.disabled = false;
    };
  };
}
