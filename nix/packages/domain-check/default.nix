{
  pkgs,
  lib,
  ...
}: let
in
  pkgs.rustPlatform.buildRustPackage (finalAttrs: {
    pname = builtins.baseNameOf ./.;
    version = "v0.6.0";

    meta = {
      description = ''
        High-performance Rust library & CLI for domain availability checks
        using RDAP & WHOIS, with async concurrency, bulk processing, and robust
        error handling.
      '';
      homepage = "https://github.com/saidutt46/domain-check";
      licenses = with pkgs.licenses; [asl2];
      maintainers = [];
      platforms = lib.platforms.all;
      mainProgram = finalAttrs.pname;
    };

    src = pkgs.fetchFromGitHub {
      owner = "saidutt46";
      repo = finalAttrs.pname;
      tag = finalAttrs.version;
      sha256 = "sha256-QH3gkFPKNnULG+QTmaPg1Gb9KD99ao7BCkFeJQcZFu8=";
    };

    cargoHash = "sha256-60BDLAwpSKvdiFs+Gg7h3kEVbD4MwMVmIJOIS0Yvoio=";
  })
