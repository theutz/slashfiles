{
  description = "/slashfiles: .dotfiles{everywhere}";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";

		snowfall-lib = {
			 url = "github:snowfallorg/lib";
       inputs.nixpkgs.follows = "nixpkgs";
		};

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows =  "nixpkgs";
    };

    darwin = {
        url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    lib = inputs.snowfall-lib.mkLib {
      inherit inputs;
      src = ./.;
    };
  in lib.mkFlake {
    channels-config = { allowUnfree = true; };
	};
}
