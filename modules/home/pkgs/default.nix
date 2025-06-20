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
        (pkgs.${namespace} |> lib.attrValues)
        (with pkgs; [
          aichat
          claude-code
          codex
          comma
          coreutils
          curlie
          fd
          gping
          httpie
          lazygit
          nix-output-monitor
          ookla-speedtest
          procs
          ripgrep
          spotify-player
          xh
          zoom-us
        ])
        (lib.optional (! pkgs.stdenv.isDarwin) [
          pkgs.httpie-desktop
          pkgs.signal-desktop-bin
          pkgs.tailscale
        ])
        (with pkgs.nerd-fonts; [
          blex-mono
          roboto-mono
          recursive-mono
        ])
      ]
      |> lib.concatLists
      |> lib.flatten;
  };
}
