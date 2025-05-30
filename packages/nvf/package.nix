{
  pkgs,
  lib,
  nvf',
  ...
}: let
  currentFile = /. + __curPos.file;
  mods = lib.pipe ./. [
    lib.filesystem.listFilesRecursive
    (lib.filter (f: f != currentFile))
  ];
in
  (nvf'.lib.neovimConfiguration {
    inherit pkgs;

    modules =
      mods
      ++ [
        {
          config = {
            fzf-lua.enable = true;
            session.enable = true;
            vim = {
              formatter.conform-nvim.enable = true;

              git.enable = true;

              languages = {
                enableExtraDiagnostics = true;
                enableFormat = true;
                enableTreesitter = true;
                nix.enable = true;
                nix.extraDiagnostics = {
                  enable = true;
                  types = ["statix" "deadnix"];
                };
                bash.enable = true;
              };

              lazy.plugins = {
                neogit = {
                  package = pkgs.vimPlugins.neogit;
                };
              };

              statusline.lualine.enable = true;

              theme = {
                enable = true;
                name = "catppuccin";
                style = "mocha";
                transparent = true;
              };

              ui.borders.enable = true;

              utility = {
                motion = {
                  flash-nvim = {
                    enable = true;
                  };
                };
                surround.enable = true;
                yazi-nvim.enable = true;
              };
            };
          };
        }
      ];
  }).neovim
