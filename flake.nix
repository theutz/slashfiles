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

      homes.modules = with inputs; [
        nvf.homeManagerModules.default
      ];

      channels-config = {
        allowUnfree = true;
        allowUnsupportedSystem = true;
        permittedInsecurePackages = [];
        config = {};
      };
    };
}
