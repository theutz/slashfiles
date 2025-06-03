{
  lib,
  namespace,
  ...
}: let
  listNixFilesRecursive = pipe [
    lib.filesystem.listFilesRecursive
    filterNixFiles
  ];

  filterNixFiles = lib.filter (lib.hasSuffix "nix");
  filterDefaultNixFiles = lib.filter (lib.hasSuffix "default.nix");
  pipe = lib.flip lib.pipe;

  flatConcat = pipe [lib.concatLists lib.flatten];

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
in {
  inherit mkModule flatConcat pipe listNixFilesRecursive filterNixFiles filterDefaultNixFiles;
}
