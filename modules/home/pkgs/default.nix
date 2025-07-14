{
  pkgs,
  namespace,
  config,
  lib,
  ...
}: let
  cfg = config.${namespace}.${mod};
  mod = baseNameOf ./.;
in {
  options.${namespace}.${mod}.enable = lib.mkEnableOption "enable ${mod}";

  config = lib.mkIf cfg.enable {
    home.packages =
      [
        # My custom packages
        (pkgs.${namespace} |> lib.attrValues)

        # Basic nixpkgs stuff
        (with pkgs; [
          aichat
          claude-code
          comma
          coreutils
          curlie
          fd
          gemini-cli
          google-chrome
          gping
          httpie
          lazygit
          nix-output-monitor
          ookla-speedtest
          procs
          ripgrep
          sd
          spotify-player
          tenki
          volgo
          xh
          zoom-us
        ])

        # Darwin only
        (lib.optional (pkgs.stdenv.isDarwin) (with pkgs; [
          codex
        ]))

        # Linux only
        (lib.optional (pkgs.stdenv.isLinux) (with pkgs; [
          slack
          httpie-desktop
          signal-desktop-bin
          tailscale
        ]))

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
