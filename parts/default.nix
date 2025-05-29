{
  imports = [
    ./pkgs # Per-system packages exposed by flake
    ./shell.nix # `nix develop` shell for working on this flake
  ];
}
