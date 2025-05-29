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
      autoArgs =
        pkgs
        // {
          inherit inputs inputs';
          nvf' = inputs.nvf;
        };

      callPackage = lib.callPackageWith autoArgs;

      packages =
        lib.packagesFromDirectoryRecursive {
          inherit callPackage;
          directory = ./.;
        }
        // {default = config.packages.swch;};
    in
      packages;
  };
}
