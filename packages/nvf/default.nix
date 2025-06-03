{
  pkgs,
  lib,
  inputs,
  namespace,
  ...
}: let
  currentFile = /. + __curPos.file;
in
  (inputs.nvf.lib.neovimConfiguration {
    inherit pkgs;

    extraSpecialArgs = {
      inherit namespace;
      lib' = lib.${namespace};
    };

    modules = lib.pipe ./. [
      lib.filesystem.listFilesRecursive
      (lib.filter (f: f != currentFile))
    ];
  }).neovim
