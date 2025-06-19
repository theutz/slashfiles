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
    programs.git.delta.enable = true;
  };
}
