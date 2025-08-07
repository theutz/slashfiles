{
  lib,
  namespace,
  ...
}:
{
  mkMod' = config: path: rec {
    mod = builtins.baseNameOf path;
    cfg = config.${namespace}.${mod};

    mkEnableOption = lib.mkEnableOption "enable ${mod}";

    mkOptions = opts: {
      ${namespace}.${mod} = {
        enable = mkEnableOption;
      }
      // opts;
    };

    mkConfig =
      c:
      if lib.isAttrs c then
        lib.mkIf cfg.enable c
      else
        assert lib.isList c;
        lib.mkMerge c;

    mkMod = c: {
      options = mkOptions { };
      config = mkConfig c;
    };
  };

  list-other-files =
    path:
    let
      inherit (lib.fileset) toList fileFilter;
    in
    toList (
      fileFilter (
        {
          name,
          hasExt,
          type,
          ...
        }:
        (type == "regular") && name != "default.nix" && hasExt "nix"
      ) path
    );

  genEnabledMods =
    list:
    (
      if lib.isString list then
        list |> lib.trim |> lib.splitString "\n"
      else
        assert lib.isList list;
        list
    )
    |> (lib.flip lib.genAttrs) (_: {
      enable = true;
    });
}
