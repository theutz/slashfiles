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
    xdg.configFile."karabiner/karabiner.json".source = ./karabiner.json;
  };
}
