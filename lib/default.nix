{
  lib,
  namespace,
  ...
}: let
  filesystem = {
    listNixFilesRecursive = func.pipe [
      lib.filesystem.listFilesRecursive
      path.filters.nixFiles
    ];

    listNextLevelDefaults = p:
      lib.pipe p [
        lib.filesystem.listFilesRecursive
        (lib.map builtins.toString)
        (lib.filter (
          f:
            ((lib.strings.match (
                builtins.toString (
                  p + "/[^/]+/default.nix"
                )
              ))
              f)
            != null
        ))
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
      defaultsOneDeep = p:
        lib.filter (
          f:
            ((lib.strings.match (
                builtins.toString (
                  p + "/[^/]+/default.nix"
                )
              ))
              f)
            != null
        );
    };
  };

  func = {
    pipe = lib.flip lib.pipe;
  };

  lists = {
    flatConcat = func.pipe [lib.concatLists lib.flatten];
  };

  modules = {
    mkModule = {
      here,
      config,
    }: mod': let
      name = builtins.baseNameOf here;
      cfg = config.${namespace}.${name};
      mod = mod' {inherit cfg;};
    in {
      inherit (mod) config;
      options.${namespace}.${name} = mod.options;
    };
  };
in {
  inherit lists func path filesystem modules;
}
