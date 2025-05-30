{
  pkgs,
  config,
  ...
}: {
  # config = lib.mkIf cfg.enable {
  # homebrew.brews = import ./brew
  config = {
    environment.systemPackages = with pkgs; [
      ripgrep
      pam-reattach
      fd
      git
    ];

    environment.shells = with pkgs; [
      bashInteractive
      fish
      zsh
      nushell
    ];

    homebrew = {
      enable = true;

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
      ];

      onActivation = {
        autoUpdate = false; # default
        cleanup = "zap";
      };
      taps = [];
    };
  };
}
