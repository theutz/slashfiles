{
  description = "/slashfiles: .dotfiles{everywhere}";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOs/nixpkgs/nixpkgs-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs.follows = "unstable";
    };

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "unstable";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.mkLib { inherit inputs; } (
      top@{
        config,
        withSystem,
        moduleWithSystem,
        ...
      }:
      {
        imports = [ ];
        flake = { };
        systems = [
          "x86_64-linux"
          "aarch64-darwin"
        ];
        perSystem = { config, pkgs, ... }: { };
      }
    );
}
