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

    homebrew = {
      enable = true;
      taps = [];

      brews = [
        "dark-mode"
        "dark-notify"
      ];

      casks = [
        "figma"
        "httpie"
        "karabiner-elements"
        "mouseless@preview"
        "orion"
        "signal"
        "slack"
        "spotify"
        "tailscale"
        "telegram"
        "vivaldi"
      ];

      onActivation = {
        autoUpdate = false; # default
        cleanup = "zap";
      };
    };
  };
}
