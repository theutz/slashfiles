{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkConfig mkOptions;
in
{
  imports = lib.${namespace}.list-other-files ./.;

  options = mkOptions { };

  config = mkConfig {
    home.shell.enableShellIntegration = true;
    programs.starship.enable = true;
    programs.starship.settings = {
      shell.disabled = false;
    };
  };
}
