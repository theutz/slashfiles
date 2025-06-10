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
      ];

      casks = [
        "figma"
        "vivaldi"
        "karabiner-elements"
        "spotify"
        "slack"
        "telegram"
        "mouseless@preview"
        "httpie-desktop"
      ];

      onActivation = {
        autoUpdate = false; # default
        cleanup = "zap";
      };
    };
  };
}
