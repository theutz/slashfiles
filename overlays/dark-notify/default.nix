_: _final: prev: let
  name = baseNameOf ./.;
in {
  ${name} = prev.pkgs.rustPlatform.buildRustPackage {
    pname = name;
    version = "master";

    meta = {
      description = ''
        Watcher for macOS 10.14+ light/dark mode changes
      '';
      homepage = "https://github.com/cormacrelf/dark-notify";
      license = [];
      maintainers = [];
      platforms = prev.lib.platforms.darwin;
      mainProgram = name;
    };

    src = prev.fetchFromGitHub {
      owner = "cormacrelf";
      repo = "dark-notify";
      rev = "0d8501ca027b4355ed958b937ed51b37632c60cf";
      hash = "sha256-r71Xe8nBaio0+DP4Q+tljtACPvKlT4URbBS5qq58msE=";
    };

    cargoHash = "sha256-xICF/BAu+Gbg9rXhPgu2NKxQyFAuSGCPYEHAUsUCWrY=";
  };
}
