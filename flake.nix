{
  # This flake is heavily inspired by @NotAShelf's github.com/notashelf/nyx
  description = "/slashfiles: .dotfiles/{everywhere}.nix";

  # Define the libraries that will define our system.
  inputs = {
    # I like to stay stable as my base, occasionally overriding with
    # unstable.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";

    # For those cutting-edge cases
    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Home Manager: dotfiles, dotfiles
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Darwin: NixOS configuration for macOS
    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Neovim Flake: Takes the pain out of customizing neovim with nix
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "unstable";
    };

    # A nice way to modularize your flake for multiple systems
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Format all the things
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix wrapper that brings me joy
    nh = {
      url = "github:nix-community/nh";
      inputs.nixpkgs.follows = "unstable";
    };

    # secrets with sops
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Bootstrap point for this whole, lovely mess.
  outputs = inputs: let
    namespace = "slashfiles";
  in
    inputs.snowfall-lib.mkFlake {
      inherit inputs;

      src = ./.;

      snowfall = {
        inherit namespace;
        meta = {
          name = namespace;
          title = "/slashfiles: .dotfiles/{everywhere}.nix";
        };
      };

      systems.modules.darwin = [
        inputs.sops-nix.darwinModules.sops
      ];

      alias = {
        shells.default = namespace;
      };

      outputs-builder = channels: let
        pkgs = channels.nixpkgs;
        treefmt = inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      in {
        formatter = treefmt.config.build.wrapper;
        checks = {formatting = treefmt.config.build.check inputs.self;};
      };

      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = [];
        config = {};
      };
    };
}
