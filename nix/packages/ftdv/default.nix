{
  pkgs,
  lib,
  ...
}: let
  name = builtins.baseNameOf ./.;
in
  pkgs.rustPlatform.buildRustPackage (finalAttrs: {
    pname = name;
    version = "v0.1.2";
    meta = {
      description = ''
        FILE TREE DIFF VIEWER
      '';
    };

    src = pkgs.fetchFromGitHub {
      owner = "wtnqk";
      repo = "ftdv";
      tag = finalAttrs.version;
      sha256 = "sha256-J1lWrfZeH/V1hckLGWDoeU6aKFoLimddzaTKMQ8sDs8=";
    };

    cargoHash = "sha256-ZFIlDwq0qmBfL/GL7fMetUWuUhq6ywDt060dyoSCFqA=";
  })
