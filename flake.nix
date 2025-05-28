{
  # This flake is heavily inspired by @NotAShelf's github.com/notashelf/nyx
  description = "/slashfiles: .dotfiles/{everywhere}.nix";

  # Bootstrap point for this whole, lovely mess.
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import inputs.systems;

      imports = [
        ./parts
        # ./hosts
      ];
    };

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
      inputs.flake-parts.follows = "flake-parts";
    };

    # Used to modularize this flake
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Standard definitions for flake-parts' `systems` attribute
    # Can be changed to `/default-linux` to support only linux,
    # or to `/default` to support everything. Generally, a smaller
    # set should improve nix performance.
    systems.url = "github:nix-systems/default-darwin";

    # Format all the things
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # outputs = inputs @ {
  #   nixpkgs,
  #   nix-darwin,
  #   home-manager,
  #   ...
  # }: let
  # forAllSystems = nixpkgs.lib.genAttrs [
  #   "aarch64-darwin"
  # ];

  # packages = forAllSystems (
  #   system: let
  #     pkgs = nixpkgs.legacyPackages.${system};
  #   in {
  #     nvim = pkgs.callPackage (import ./packages/nvim) {inherit (inputs.nvf) lib;};
  #   }
  # );
  # in {
  # inherit packages;

  #   darwinConfigurations = let
  #     system = "aarch64-darwin";
  #     pkgs = nixpkgs.legacyPackages.${system};
  #   in {
  #     kocaeli = nix-darwin.lib.darwinSystem {
  #       inherit system;
  #       modules = [
  #         home-manager.darwinModules.home-manager
  #         ((import ./hosts/kocaeli) {
  #           inherit inputs system;
  #           pkgs = pkgs // packages.${system};
  #         })
  #       ];
  #     };
  #   };
  #
  #   devShells = forAllSystems (
  #     system: let
  #       pkgs = nixpkgs.legacyPackages.${system};
  #     in rec {
  #       default = slashfiles;
  #       slashfiles = import ./shells/slashfiles {
  #         inherit pkgs;
  #         inherit (packages.${system}) nvim;
  #       };
  #     }
  #   );
  #
  #   formatter = forAllSystems (
  #     system: let
  #       pkgs = nixpkgs.legacyPackages.${system};
  #     in
  #       pkgs.alejandra
  #   );
  # };
}
