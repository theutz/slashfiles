{
  description = "slashfiles";

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
  };

  outputs = inputs: let
    lib = inputs.snowfall-lib.mkLib {
      inherit inputs;
      src = ./.;
      snowfall = {
        root = ./nix;
        namespace = "slashfiles";
      };
    };
  in
    lib.mkFlake {
      inherit lib inputs;

      systems.modules.nixos = with inputs; [
        sops-nix.nixosModules.sops
      ];

      homes.modules = with inputs; [
        nvf.homeManagerModules.default
        sops-nix.homeManagerModules.sops
      ];

      channels-config = {
        allowUnfree = true;
        allowUnsupportedSystem = true;
        permittedInsecurePackages = [];
        config = {};
      };
    };
}
