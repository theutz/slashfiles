{
  namespace,
  lib,
  pkgs,
  config,
  ...
}:
{
  system = {
    primaryUser = lib.${namespace}.primaryUser;

    stateVersion = 5;
  };

  nix = {

    enable = true;

    checkConfig = true;

    gc.automatic = true;

    optimise.automatic = true;

    settings.trusted-users = ["@admin"];

    settings.experimental-features = ["nix-command" "flakes" "pipe-operators"];
  };

  environment = {
    systemPackages = with pkgs; [
      home-manager
      nh
      mise
      chezmoi
      floorp
      sops
      firefox
      lazygit
      eza
      fish
      nushell
      bashInteractive
      zsh
      karabiner-elements
      wezterm
      # vivaldi
    ];

    variables = {
      NH_FLAKE = "/Users/" + config.system.primaryUser + "/slashfiles";
    };
  };

  homebrew = {
    enable = true;

    global. autoUpdate = false;

    onActivation = {
      autoUpdate = false;
      cleanup = "zap";
      upgrade = false;
    };

    brews = [
      "pueue"
    ];

    casks = [];

    taps = [];

    masApps = {};

    whalebrews = [];
  };
}
