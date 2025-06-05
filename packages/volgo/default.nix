{
  pkgs,
  lib,
  ...
}: let
  version = "0.0.1";
in
  pkgs.buildGoModule {
    inherit version;
    pname = "volgo";
    meta = {
      description = ''
        Cross-platform CLI app for controlling system volume from the terminal.
      '';
      homepage = "https://github.com/elliot40404/volgo";
      license = lib.licenses.mit;
    };

    src = pkgs.fetchFromGitHub {
      owner = "elliot40404";
      repo = "volgo";
      rev = "v${version}";
      hash = "sha256-hl59VzUFHwWJVSiwZ8kBCEFP2DjIGjZQBtMg1Fo8eqQ=";
    };

    vendorHash = null;
  }
