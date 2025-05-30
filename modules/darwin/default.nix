{lib, ...}: let
  currentFile = /. + __curPos.file;
  modules = lib.pipe ./. [
    lib.filesystem.listFilesRecursive
    (lib.filter (f: f != currentFile))
  ];
in {
  imports = modules;
}
