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
    home.packages =
      [
        (with pkgs.${namespace}; [
          volgo
          thome
          comt
          nvf
        ])
        (with pkgs; [
          comma
          zoom-us
          coreutils
          fd
          lazygit
          procs
          ripgrep
          aichat
          spotify-player
          curlie
          xh
          httpie
        ])
        (lib.optional (! pkgs.stdenv.isDarwin) [
          pkgs.httpie-desktop
          pkgs.tailscale
          pkgs.signal-desktop-bin
        ])
        (with pkgs.nerd-fonts; [
          roboto-mono
          blex-mono
        ])
      ]
      |> lib.concatLists
      |> lib.flatten;
  };
}
