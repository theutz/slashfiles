{
  withSystem,
  inputs,
  ...
}: {
  flake.darwinConfigurations = {
    kocaeli = let
      system = "aarch64-darwin";
    in
      withSystem system ({
        config,
        inputs',
        ...
      }:
        inputs.nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            packages = config.packages;
            inherit inputs inputs';
          };
          modules = [
            inputs.home-manager.darwinModules.home-manager
            ../modules/darwin
            ./kocaeli
          ];
        });
  };
}
