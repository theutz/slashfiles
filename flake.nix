{
	description = "/slashfiles: .dotfiles{everywhere}";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
                unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

		snowfall-lib = {
			 url = "github:snowfallorg/lib";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		home-manager = {
			url = "github:nix-community/home-manager/release-25.05";
			inputs.nixpkgs.follows =  "nixpkgs";
		};

		darwin = {
			url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nvf = {
			url = "github:notashelf/nvf";
			inputs.nixpkgs.follows = "unstable";
		};
	};

	outputs = inputs: let
		lib = inputs.snowfall-lib.mkLib {
			inherit inputs;
			src = ./.;
		};
	in lib.mkFlake {
		channels-config = { allowUnfree = true; };

		homes.modules = with inputs; [
			nvf.homeManagerModules.default
		];

                alias = {
                        shells.default = "dev";
                };
	};
}
