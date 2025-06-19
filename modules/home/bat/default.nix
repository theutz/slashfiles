{
  pkgs,
  lib,
  config,
  ...
}:
lib.slashfiles.mkModule {
  inherit config;
  here = ./.;
} {
  config = {
    home.shellAliases = {
      cat = "bat";
    };
    programs.bat = {
      enable = true;
      config = {theme = "ansi";};
      extraPackages = with pkgs.bat-extras; [batman batwatch batdiff batgrep];
      syntaxes = {
        tmux = {
          src = pkgs.fetchFromGitHub {
            owner = "kei-q";
            repo = "sublime-tmux-syntax-highlight";
            rev = "9162993af1eab09413cd141a640cbffe7122d1de";
            hash = "sha256-B2gypmQh1GWh/0UaD+BFbBumGhIYmrq0KpCAkgrK4ws=";
          };
          file = "Tmux.tmLanguage";
        };
      };
    };
  };
}
