# vim: et ts=2 sts=2 sw=2
{
  description = "/slashfiles: .dotfiles{everywhere}";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    ez-configs = {
      url = "github:ehllie/ez-configs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake
    { inherit inputs; }
    {
      imports = [ inputs.ez-configs.flakeModule ];
      
      systems = [ "aarch64-darwin" ];

      ezConfigs = {
        root = ./.;
        globalArgs = { inherit inputs; };
      };
    };
}
