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
        # My custom packages
        (pkgs.${namespace} |> lib.attrValues)

        # Basic nixpkgs stuff
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
          tenki
          xh
          zoom-us
        ])

        # Linux only
        (lib.optional (! pkgs.stdenv.isDarwin) [
          pkgs.httpie-desktop
          pkgs.signal-desktop-bin
          pkgs.tailscale
        ])

        # Nerd fonts
        (pkgs.nerd-fonts
          |> lib.filterAttrs (
            name: _: (lib.any (name': name == name')
              lib.${namespace}.prefs.font.nerdfonts)
          )
          |> lib.attrValues)
        # (with pkgs.nerd-fonts; [
        #   blex-mono
        #   roboto-mono
        #   recursive-mono
        #   lilex
        #   hack
        #   fira-code
        #   sauce-code-pro
        #   hasklug
        #   monaspace
        # ])
      ]
      |> lib.concatLists
      |> lib.flatten;
  };
}
