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
      my-pkgs = {
        inherit inputs inputs';
        nvf' = inputs.nvf;
      };

      callPackage = lib.callPackageWith (pkgs // my-pkgs);
    in
      lib.packagesFromDirectoryRecursive {
        inherit callPackage;
        directory = ./.;
      };
  };
}
