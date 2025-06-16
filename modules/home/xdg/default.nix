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
    home.preferXdgDirectories = true;
    xdg.enable = true;
  };
}
