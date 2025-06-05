{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) mkModule;
in
  mkModule {
    inherit config;
    here = ./.;
  } {
    config = {
      programs.mise = {
        enable = true;
      };
    };
  }
