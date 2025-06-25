_: _final: prev: let
  name = baseNameOf ./.;
  version = "0.0.1";
in {
  ${name} = prev.buildGoModule {
    inherit version;
    pname = name;
    meta = {
      description = ''
        Cross-platform CLI app for controlling system volume from the terminal.
      '';
      homepage = "https://github.com/elliot40404/volgo";
      license = prev.lib.licenses.mit;
      mainProgram = name;
    };

    src = prev.fetchFromGitHub {
      owner = "elliot40404";
      repo = "volgo";
      rev = "v${version}";
      hash = "sha256-hl59VzUFHwWJVSiwZ8kBCEFP2DjIGjZQBtMg1Fo8eqQ=";
    };

    vendorHash = null;
  };
}
