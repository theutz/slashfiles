{

  nix.settings.experimental-features = [
    "nix-command"
    "pipe-operators"
    "flakes"
  ];

  #
  # nixpkgs.config.allowUnfree = true;
  #
}
