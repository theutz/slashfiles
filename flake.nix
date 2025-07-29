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
  };

  outputs = inputs: let
    lib = inputs.snowfall-lib.mkLib {
      inherit inputs;
      src = ./.;
      snowfall.root = ./nix;
      snowfall.namespace = "slashfiles";
    };
  in lib.mkFlake {
    inherit lib inputs;
    channels-config.allowUnfree = true;
    channels-config.allowUnsupportedSystem = true;
    channels-config.permittedInsecurePackages = [];
    channels-config.config = {};
  };
}
