{
  pkgs,
  lib,
  nvf',
  ...
}:
(nvf'.lib.neovimConfiguration {
  inherit pkgs;

  modules = [
    {
      config.vim = {
        formatter.conform-nvim.enable = true;

        fzf-lua.enable = true;

        git.enable = true;

        languages = {
          enableExtraDiagnostics = true;
          enableFormat = true;
          enableTreesitter = true;
          nix.enable = true;
          bash.enable = true;
        };

        lazy.plugins = {
          neogit = {
            package = pkgs.vimPlugins.neogit;
          };
        };

        session = {
          nvim-session-manager = {
            enable = true;
            setupOpts = {
              autoload_mode = "CurrentDir";
            };
          };
        };

        statusline.lualine.enable = true;

        theme = {
          enable = true;
          name = "dracula";
          transparent = true;
        };

        ui.borders.enable = true;

        utility = {
          surround.enable = true;
          yazi-nvim.enable = true;
        };
      };
    }
    ./diagnostics.nix
    ./lsp.nix
    ./treesitter.nix
    ./keymaps.nix
  ];
}).neovim
