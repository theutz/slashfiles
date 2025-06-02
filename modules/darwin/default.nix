{inputs, ...}: {
  imports = [
    ./packages
    inputs.sops-nix.darwinModules.sops
  ];
}
