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
    mod =
      if lib.isFunction mod'
      then mod' {inherit cfg;}
      else if lib.isAttrs mod'
      then mod'
      else throw "Wrong type";
  in {
    options.${namespace}.${name} = {enable = lib.mkEnableOption "enable ${name}";} // (mod.options or {});
    config = lib.mkIf cfg.enable mod.config;
  };
in {
  inherit mkModule flatConcat pipe listNixFilesRecursive filterNixFiles filterDefaultNixFiles;
}
