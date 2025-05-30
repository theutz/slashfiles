{lib, ...}: let
  lib' = rec {
    filesystem = {
      listNixFilesRecursive = func.pipe [
        lib.filesystem.listFilesRecursive
        path.filters.nixFiles
      ];
    };

    path = {
      components = func.pipe [
        lib.path.subpath.splitRoot
        (f: f.subpath)
        lib.path.subpath.components
      ];

      depth = func.pipe [
        path.components
        lib.length
      ];

      filters = {
        nixFiles = lib.filter (lib.hasSuffix "nix");
        defaultFiles = lib.filter (lib.hasSuffix "default.nix");
      };
    };

    func = {
      pipe = lib.flip lib.pipe;
    };

    lists = {
      flatConcat = func.pipe [lib.concatLists lib.flatten];
    };
  };
in {
  flake.lib = lib';

  perSystem = {
    _module.args = {inherit lib';};
  };
}
