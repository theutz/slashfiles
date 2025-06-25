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
          google-chrome
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

        # Fonts
        (lib.${namespace}.prefs.font.packages
          |> lib.map (p:
            p
            |> lib.strings.splitString "."
            |> (lib.flip lib.attrsets.getAttrFromPath pkgs)))
      ]
      |> lib.concatLists
      |> lib.flatten;
  };
}
