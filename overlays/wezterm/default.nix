{inputs, ...}: _: prev: {
  inherit (inputs.unstable.legacyPackages.${prev.system}) wezterm;
}
