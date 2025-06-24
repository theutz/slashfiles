args @ {
  lib,
  namespace,
  ...
}: let
  filterNixFiles = lib.filter (lib.hasSuffix "nix");
  filterDefaultNixFiles = lib.filter (lib.hasSuffix "default.nix");
in {
  inherit filterNixFiles filterDefaultNixFiles;

  ## Create and inject common modules into standard module paths
  ## Source: https://github.com/ProjectInitiative/dotfiles/blob/43d7ae752c6340c8b2138f875fc2db62e37a6602/lib/default.nix#L26
  #@ Path -> AttrSet
  create-common-modules = common-path: let
    common-modules = lib.snowfall.module.create-modules {
      src = lib.snowfall.fs.get-snowfall-file common-path;
      overrides = lib.full-flake-options.modules.common or {};
      alias = lib.alias.modules.common or {};
    };

    # Debug trace that won't break JSON serialization
    _ = builtins.trace "Created modules: ${toString (builtins.attrNames common-modules)}" null;
  in
    common-modules;

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
