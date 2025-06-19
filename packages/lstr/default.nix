{pkgs, ...}:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "lstr";
  version = "0.2.0";

  meta = {
    description = ''
      A fast, minimalist directory tree viewer, written in Rust.
    '';
    homepage = "https://crates.io/crates/lstr";
    license = [];
    maintainer = [];
  };

  src = pkgs.fetchFromGitHub {
    owner = "bgreenwell";
    repo = "lstr";
    rev = "v${version}";
    hash = "sha256-Bg2tJYnXpJQasmcRv+ZIZAVteKUCuTgFKVRHw1CCiAQ=";
  };

  cargoHash = "sha256-KlO/Uz9UPea4DFC6U4hvn4kOWSzUmYmckw+IUstcmeQ=";

  checkFlags = [
    # Requires tmpdir in target
    "--skip=test_git_status_flag"
    "--skip=test_gitignore_flag"
  ];

  nativeBuildInputs = with pkgs; [pkg-config];
  buildInputs = with pkgs; [openssl];
}
