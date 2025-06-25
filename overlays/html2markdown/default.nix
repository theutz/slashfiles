_: _final: prev: let
  name = baseNameOf ./.;
  version = "2.3.3";
in {
  ${name} = prev.buildGoModule {
    inherit version;
    pname = name;
    meta = {
      description = "Convert HTML to Markdown.";
      homepage = "https://html-to-markdown.com";
      license = prev.lib.licenses.mit;
      mainProgram = name;
    };

    src = prev.fetchFromGitHub {
      owner = "JohannesKaufmann";
      repo = "html-to-markdown";
      rev = "v${version}";
      hash = "sha256-B+ZJk86VJUscaf91tv5uuTeL6u9HN6cS+5+4TOiNC+E=";
    };

    vendorHash = "sha256-nMb4moiTMzLSWfe8JJwlH6H//cOHbKWfnM9SM366ey0=";
  };
}
