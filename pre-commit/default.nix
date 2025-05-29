{
  inputs,
  lib,
  ...
}: {
  imports = [inputs.git-hooks.flakeModule];

  perSystem = let
    inherit (import ./utils.nix {inherit lib;}) excludes mkHook;
  in
    _: {
      pre-commit = {
        check.enable = true;

        settings = {
          inherit excludes;

          hooks = {
            luacheck = mkHook "luacheck" {enable = true;};
            treefmt = mkHook "treefmt" {enable = true;};
            alejandra = mkHook "alejandra" {enable = true;};
            lychee = mkHook "lychee" {enable = true;};
            editorconfig-checker = mkHook "editorconfig" {
              enable = true;
            };
          };
        };
      };
    };
}
