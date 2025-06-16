{inputs, ...}: _: prev: {
  wezterm = inputs.unstable.legacyPackages.${prev.system}.wezterm;
}
