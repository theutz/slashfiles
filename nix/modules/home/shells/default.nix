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
    programs.starship = {
      enable = true;
      settings = {
        shell.disabled = false;
      };
    };

    programs.bash.enable = true;

    programs.fish.enable = true;

    programs.nushell.enable = true;
  };
}
