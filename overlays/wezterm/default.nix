{inputs, ...}: _: prev: {
  wezterm = inputs.nixpkgs.legacyPackages.${prev.system}.wezterm;
}
