{
  pkgs,
  lib,
  inputs,
  namespace,
  ...
}:
(inputs.nvf.lib.neovimConfiguration {
  inherit pkgs;

  extraSpecialArgs = {
    inherit namespace;
    lib' = lib.${namespace};
  };

  modules = lib.filesystem.listFilesRecursive ./modules;
}).neovim
