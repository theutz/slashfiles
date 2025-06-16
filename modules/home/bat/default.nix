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
    home.shellAliases = {
      cat = "bat";
    };
    programs.bat = {
      enable = true;
      config = {theme = "ansi";};
    };
  };
}
