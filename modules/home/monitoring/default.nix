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
    programs.btop = {
      enable = true;
      settings = {
        theme_backgrounnd = false;
        vim_keys = true;
        rounded_corners = true;
        graph_symbol = "braille";
      };
    };
  };
}
