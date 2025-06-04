{
  pkgs,
  namespace,
  config,
  lib,
  ...
}:
lib.${namespace}.mkModule {
  inherit config;
  here = ./.;
} {
  config = {
    home.packages = with pkgs;
      [
        comma
        zoom-us
        coreutils
        fd
        lazygit
        procs
        ripgrep
        aichat
        signal-desktop-bin
        spotify-player
      ]
      ++ (with nerd-fonts; [
        roboto-mono
        blex-mono
      ]);
  };
}
