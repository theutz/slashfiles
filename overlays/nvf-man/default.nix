{inputs, ...}: _final: prev: {
  nvf-man = inputs.nvf.packages.${prev.system}.docs-manpages;
}
