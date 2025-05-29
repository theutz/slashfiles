{lib, ...}: let
  inherit (lib.attrsets) recursiveUpdate;

  excludes = ["flake.lock" "\.age$"];

  presetConfigFor = name: {
    inherit excludes;
    description = "pre-commit hook for ${name}";
    fail_fast = true;
    verbose = true;
  };

  mkHook = name: hookConfig: recursiveUpdate (presetConfigFor name) hookConfig;
in {
  inherit excludes mkHook;
}
