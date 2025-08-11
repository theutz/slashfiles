{
  config.vim = {
    snippets.luasnip = {
      enable = true;
      customSnippets.snipmate = {
        nix = [
          {
            trigger = "mkMod";
            body =
              # nix
              ''
                {
                  config,
                  lib,
                  namespace,
                  pkgs,
                  ...
                }:
                let
                  inherit (lib.\''${namespace}.mkMod' config ./.) mkMod;
                in
                mkMod {
                  ''$0
                }
              '';
          }
        ];
      };
    };
  };
}
