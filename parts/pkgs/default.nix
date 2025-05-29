{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.easyOverlay];
  perSystem = {
    config,
    pkgs,
    lib,
    inputs',
    ...
  }: {
    overlayAttrs = config.packages;
    packages = let
      callPackage = lib.callPackageWith (pkgs
        // {
          inherit inputs inputs';
          nvf' = inputs.nvf;
        });
    in
      lib.packagesFromDirectoryRecursive {
        inherit callPackage;
        directory = ./packages;
      };
  };
}
