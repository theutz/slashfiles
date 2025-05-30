{lib, ...}: let
  lib' = rec {
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
