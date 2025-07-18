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

    # For very unstable updates with swift by @reckenrode
    # https://github.com/NixOS/nixpkgs/issues/343210#issuecomment-2941878079
    nixpkgs-swift-update.url = "github:reckenrode/nixpkgs/swift-update";

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
      # url = "github:snowfallorg/lib";
      url = "github:theutz/snowfallorg-lib";
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

    nixos-anywhere = {
      url = "github:nix-community/nixos-anywhere";
      inputs.nixpkgs.follows = "unstable";
    };

    # disko: disk partitioning (to be used with nixos-anywhere)
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "unstable";
    };
  };

  # Bootstrap point for this whole, lovely mess.
  outputs = inputs: let
    namespace = "slashfiles";
    lib = inputs.snowfall-lib.mkLib {
      inherit inputs;

      src = builtins.path {
        path = ./.;
        name = "source";
      };

      snowfall = {
        inherit namespace;
        meta = {
          name = namespace;
          title = "/${namespace}: .dotfiles/{everywhere}.nix";
        };
      };
    };
    common-modules = lib.create-common-modules "modules/common" |> lib.attrValues;
  in
    lib.mkFlake {
      inherit lib inputs;

      systems.modules.nixos =
        [
          inputs.sops-nix.nixosModules.sops
          inputs.disko.nixosModules.disko
        ]
        ++ common-modules;

      systems.modules.darwin =
        [
          inputs.sops-nix.darwinModules.sops
        ]
        ++ common-modules;

      alias = {
        nixosConfigurations.default = "konya";
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
        allowUnsupportedSystem = true;
        permittedInsecurePackages = [];
        config = {};
      };
    };
}
