args @ {
  lib,
  namespace,
  ...
}: let
  filterNixFiles = lib.filter (lib.hasSuffix "nix");
  filterDefaultNixFiles = lib.filter (lib.hasSuffix "default.nix");
in {
  inherit filterNixFiles filterDefaultNixFiles;
  tmux = import ./tmux.nix args;
  secrets = import ./secrets.nix args;
  prefs = import ./prefs.nix args;

  flatConcat = (lib.flip lib.pipe) [lib.concatLists lib.flatten];

  listNixFilesRecursive = (lib.flip lib.pipe) [
    lib.filesystem.listFilesRecursive
    filterNixFiles
  ];

  # Must pass in `__curPos` as `here`
  thisHere = here:
    here
    |> lib.getAttr "file"
    |> builtins.baseNameOf
    |> lib.removeSuffix ".nix";

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
  in ({
      options.${namespace}.${name} =
        {
          enable = lib.mkEnableOption "enable ${name}";
        }
        // (mod.options or {});

      config = lib.mkIf cfg.enable mod.config;
    }
    // (lib.removeAttrs mod ["options" "config"]));

  enableByPath = modules:
    modules
    |> lib.map (module:
      module
      |> lib.strings.splitString "."
      |> (path: lib.setAttrByPath path {enable = true;}))
    |> lib.lists.foldr lib.recursiveUpdate {};
}
