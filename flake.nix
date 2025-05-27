{
  description = "/slashfiles: .dotfiles{everywhere}";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
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

  outputs = inputs @ {nixpkgs, ...}: let
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-darwin"
    ];

    nvim = pkgs: import ./packages/nvim {inherit inputs pkgs;};
  in {
    packages = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        nvim = nvim pkgs;
      }
    );

    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        default = slashfiles;
        slashfiles = pkgs.mkShell {
          name = "slashfiles";
          buildInputs = with pkgs; [
            (nvim pkgs)
            fish
            mask
            watchexec
            onefetch
            lazygit
          ];
          shellHook = /* bash */ ''
            alias build="mask switch"
            alias dev="mask dev"
            alias reload="exec nix develop"
            alias lg="lazygit"
            alias m="mask"
            alias d="dev"
            alias b="build"
            alias r="reload"

            onefetch
          '';
        };
      }
    );

    formatter = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        pkgs.alejandra
    );
  };
}
