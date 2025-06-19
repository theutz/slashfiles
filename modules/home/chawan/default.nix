{
  config,
  lib,
  pkgs,
  ...
}:
lib.slashfiles.mkModule {
  inherit config;
  here = ./.;
} {
  config = {
    home.packages = with pkgs; [
      libsixel
    ];

    programs.chawan = {
      enable = true;
      settings = {buffer = {images = true;};};
    };
  };
}
