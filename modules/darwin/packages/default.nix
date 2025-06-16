{
  pkgs,
  lib,
  namespace,
  config,
  ...
}:
lib.${namespace}.mkModule {
  inherit config;
  here = ./.;
} {
  config = {
    environment.systemPackages = with pkgs; [
      ripgrep
      pam-reattach
      fd
      git
      gitu
    ];

    environment.shells = with pkgs; [
      bashInteractive
      fish
      zsh
      nushell
    ];

    fonts.packages = with pkgs; [
      nerd-fonts.recursive-mono
      nerd-fonts.roboto-mono
    ];

    homebrew = {
      enable = true;
      taps = [];

      brews = [
        "dark-mode"
      ];

      casks = [
        "figma"
        "vivaldi"
        "karabiner-elements"
        "spotify"
        "slack"
        "telegram"
        "mouseless@preview"
        "httpie"
        "signal"
        "tailscale"
      ];

      onActivation = {
        autoUpdate = false; # default
        cleanup = "zap";
      };
    };
  };
}
