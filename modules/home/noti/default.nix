{
  config,
  lib,
  ...
}:
lib.slashfiles.mkModule {
  inherit config;
  here = ./.;
} {
  config = {
    programs.noti.enable = true;
  };
}
