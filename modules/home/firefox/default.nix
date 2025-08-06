{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.)
    mkMod
    ;

  bookmarks = [
    {
      name = "Nix";
      toolbar = true;
      bookmarks = [
        {
          name = "Searchix";
          url = "https://searchix.ovh";
          tags = [ "nix" ];
        }
        {
          name = "Noogle";
          url = "https://noogle.dev";
          tags = [ "nix" ];
        }
      ];
    }
  ];
in
mkMod {
  programs.firefox = {
    enable = true;

    profiles = {
      default = {
        isDefault = true;
        id = 0;
        bookmarks = {
          force = true;
          settings = bookmarks ++ [ ];
        };
      };

      work = {
        id = 1;
        bookmarks = {
          force = true;
          settings = bookmarks ++ [ ];
        };
      };
    };
  };
}
