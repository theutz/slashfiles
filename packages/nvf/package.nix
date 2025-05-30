{
  pkgs,
  lib,
  nvf',
  ...
}: let
  currentFile = /. + __curPos.file;
  modules = lib.pipe ./. [
    lib.filesystem.listFilesRecursive
    (lib.filter (f: f != currentFile))
  ];
in
  (nvf'.lib.neovimConfiguration {
    inherit pkgs modules;
  }).neovim
