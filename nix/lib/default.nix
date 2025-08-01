{
  lib,
  namespace,
  ...
}: {
  mkMod = config: path: rec {
    mod = builtins.baseNameOf path;
    cfg = config.${namespace}.${mod};
    mkEnableOption = lib.mkEnableOption "enable ${mod}";
    mkOptions = opts: {
      ${namespace}.${mod} =
        {
          enable = mkEnableOption;
        }
        // opts;
    };
    mkConfig = lib.mkIf cfg.enable;
  };

  list-other-files = path: let
    inherit (lib.fileset) toList fileFilter;
  in
    toList (
      fileFilter ({
        name,
        hasExt,
        type,
        ...
      }:
        (type == "regular")
        && name != "default.nix"
        && hasExt "nix")
      path
    );
}
