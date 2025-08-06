{
  pkgs,
  lib,
  inputs,
  stdenv,
  ...
}:
let
  inherit (inputs) pyproject-nix pyproject-build-systems uv2nix;
  # inherit (pkgs.callPackages pyproject-nix.build.util {}) mkApplication;

  # 0. Get our version of python
  python = pkgs.python314;

  # 0.1. Get the repo
  repo = pkgs.fetchFromGitHub {
    owner = "taylorwilsdon";
    repo = "netshow";
    tag = "v0.2.2";
    sha256 = "sha256-az/Jg3Lnqi+cMf9aFLMTUuRFlbm8Nt5CJvpoxqZU6FM=";
  };

  # 1. Generate info from workspace
  workspace = uv2nix.lib.workspace.loadWorkspace {
    workspaceRoot = repo;
  };

  # 2. Generate Nix Overlay from uv.lock
  uvLockedOverlay = workspace.mkPyprojectOverlay {
    sourcePreference = "wheel"; # or "sdist"
  };

  # 3. Placeholder for any necessary custom overrides
  myCustomOverrides = _final: _prev: {
  };

  # 4. Construct the final python package set
  pythonSet = (pkgs.callPackage pyproject-nix.build.packages { inherit python; }).overrideScope (
    lib.composeManyExtensions [
      pyproject-build-systems.overlays.default # For any build tools
      uvLockedOverlay
      myCustomOverrides
    ]
  );

  name = "netshow";
  p = pythonSet.${name}; # This project as a package

  # 5. Create the runtime environment
  appPythonEnv = pythonSet.mkVirtualEnv (p.pname + "-env") workspace.deps.default;
in
stdenv.mkDerivation {
  pname = p.pname;
  version = p.version;

  src = repo;

  nativeBuildInputs = with pkgs; [
    makeWrapper
    lsof
  ];
  buildInputs = [ appPythonEnv ];

  installPhase = ''
    mkdir -p $out/bin
    cp src/netshow/*.py $out/bin
    makeWrapper ${appPythonEnv}/bin/python $out/bin/${p.pname} \
      --add-flags "-m netshow.cli"
  '';

  postFixup = ''
    wrapProgram $out/bin/${p.pname} \
      --set PATH ${lib.makeBinPath [ pkgs.lsof ]}
  '';
}
