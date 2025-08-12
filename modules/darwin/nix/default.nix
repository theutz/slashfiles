{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkMod;
in
mkMod {

  nix.enable = true;
  nix.checkConfig = true;

  nix.gc = {
    automatic = true;
  };

  nix.linux-builder = {
    enable = false;
    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    ephemeral = true;
    config.boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
    maxJobs = 8;
    # config = {
    #   virtualisation = {
    #     darwin-builder = {
    #       diskSize = 40 * 1024;
    #       memorySize = 8 * 1024;
    #     };
    #     cores = 6;
    #   };
    # };
  };

  nix.optimise = {
    automatic = true;
  };

  nix.registry = {
    nixpkgs = {
      from = {
        id = "nixpkgs";
        type = "indirect";
      };
      to = {
        owner = "nixos";
        repo = "nixpkgs";
        type = "github";
        ref = "nixpkgs-25.05-darwin";
      };
    };
    unstable = {
      from = {
        id = "unstable";
        type = "indirect";
      };
      to = {
        owner = "nixos";
        repo = "nixpkgs";
        type = "github";
        ref = "nixpkgs-unstable";
      };
    };
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];
    trusted-users = [ "@admin" ];
  };

  system.checks.verifyBuildUsers = true;
  system.checks.verifyNixPath = false;
}
