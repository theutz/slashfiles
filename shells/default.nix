{
  imports = [
    ./slashfiles.nix
  ];

  perSystem = {config, ...}: {
    devShells = {
      default = config.devShells.slashfiles;
    };
  };
}
