{
  pkgs,
  lib,
  nvf',
  ...
}:
(nvf'.lib.neovimConfiguration {
  inherit pkgs;

  modules = [
    ./fzf-lua.nix
    {
      config = {
        fzf-lua.enable = true;
      };
      config.vim = {
        formatter.conform-nvim.enable = true;

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
            mappings = {
              deleteSession = "<leader>qx";
              loadLastSession = "<leader>ql";
              loadSession = "<leader>qf";
              saveCurrentSession = "<leader>qs";
            };
            setupOpts = {
              autoload_mode = lib.generators.mkLuaInline "sm.AutoloadMode.GitSession";
            };
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
    }
    ./diagnostics.nix
    ./lsp.nix
    ./treesitter.nix
    ./keymaps.nix
  ];
}).neovim
