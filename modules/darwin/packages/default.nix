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
    environment.systemPackages = import ./packages.nix {inherit pkgs;};

    environment.shells = import ./shells.nix {inherit pkgs;};

    homebrew = {
      enable = true;
      taps = [];
      brews = import ./brews.nix;
      casks = import ./casks.nix;
      onActivation = {
        autoUpdate = false; # default
        cleanup = "zap";
      };
    };
  };
}
