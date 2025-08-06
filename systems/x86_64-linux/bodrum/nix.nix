{
  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
    "pipe-operators"
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
  };
}
