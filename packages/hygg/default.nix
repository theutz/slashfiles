{
  pkgs,
  lib,
  ...
}:
let
  name = builtins.baseNameOf ./.;
  rustPlatform = pkgs.makeRustPlatform {
    cargo = pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
    rustc = pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = name;
  version = "0.1.17";

  meta = {
    description = ''
      Simplifying the way you read.
      Minimalistic Vim-like TUI document reader.
    '';
    homepage = "https://github.com/kruserr/hygg";
    licenses = with pkgs.licenses; [
      agpl3
    ];
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProrgram = name;
  };

  src = pkgs.fetchFromGitHub {
    owner = "kruserr";
    repo = "hygg";
    tag = finalAttrs.version;
    hash = "sha256-8O78LUvqURiMi8gC8lVgVXVlL5z5Ev/bIz1+mvIC0Pw=";
  };

  cargoHash = "sha256-wKpqDmQ3Tr9eYq0ZtTF06WYS8Daq9PfEewGTEvE1xGE=";

  doCheck = false;
})
