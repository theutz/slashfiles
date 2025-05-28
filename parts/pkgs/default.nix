{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.easyOverlay];
  perSystem = {
    config,
    pkgs,
    lib,
    ...
  }: {
    overlayAttrs = config.packages;
    packages = let
      callPackage = lib.callPackageWith (pkgs // {nvf' = inputs.nvf;});
    in
      lib.packagesFromDirectoryRecursive {
        inherit callPackage;
        directory = ./packages;
      };
  };
}
