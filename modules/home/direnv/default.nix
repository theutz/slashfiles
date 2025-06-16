{
  lib,
  config,
  ...
}:
lib.slashfiles.mkModule {
  inherit config;
  here = ./.;
} {
  config = {
    home.sessionVariables = {
      DIRENV_LOG_FORMAT = ""; # Quiet!
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
