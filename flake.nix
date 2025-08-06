{
  description = "/slashfiles: .dotfiles{everywhere}";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOs/nixpkgs/nixpkgs-unstable";

    snowfall-lib = {
      url = "github:theutz/snowfallorg-lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:nix-community/nh";
      inputs.nixpkgs.follows = "unstable";
    };

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "unstable";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "unstable";
    };

    wiremix = {
      url = "github:tsowell/wiremix";
      inputs.nixpkgs.follows = "unstable";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "unstable";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pyproject-nix.follows = "pyproject-nix";
      };
    };

    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pyproject-nix.follows = "pyproject-nix";
        uv2nix.follows = "uv2nix";
      };
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nil_ls = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "unstable";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "unstable";
    };
  };

  outputs =
    inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = builtins.path {
          path = ./.;
          name = "source";
        };
        snowfall = {
          # root = ./nix;
          namespace = "slashfiles";
        };
      };
    in
    lib.mkFlake {
      inherit lib inputs;

      overlays = with inputs; [
        nur.overlays.default
        rust-overlay.overlays.default
      ];

      systems.modules.nixos = with inputs; [
        sops-nix.nixosModules.sops
      ];

      homes.modules = with inputs; [
        sops-nix.homeManagerModules.sops
      ];

      channels-config = {
        allowUnfree = true;
        allowUnsupportedSystem = true;
        permittedInsecurePackages = [ ];
        config = { };
      };

      outputs-builder =
        channels:
        let
          pkgs = channels.nixpkgs;
          treefmt = inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
        in
        {
          formatter = treefmt.config.build.wrapper;
          checks = {
            formatting = treefmt.config.build.check inputs.self;
          };
        };
    };
}
