{
  config,
  lib,
  ...
}: let
  inherit (lib.slashfiles.mkMod config ./.) mkConfig mkOptions;
in {
  imports = lib.slashfiles.list-other-files ./.;

  options = mkOptions {};

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
