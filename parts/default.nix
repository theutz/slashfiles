{
  imports = [
    ./pkgs # Per-system packages exposed by flake

    ./fmt.nix # Formatter configurations for tree-fmt
    ./shell.nix # `nix develop` shell for working on this flake
  ];
}
