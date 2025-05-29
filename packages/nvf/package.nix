{
  nvf',
  pkgs,
  ...
}: let
  inherit (nvf'.lib) neovimConfiguration nvim;
  inherit (nvim.binds) mkKeymap;
in
  (neovimConfiguration {
    inherit pkgs;

    modules = [
      {
        config.vim = {
          keymaps = [
            (mkKeymap "n" "<leader>," "<cmd>FzfLua buffers<cr>" {desc = "Open buffers...";})
            (mkKeymap "n" "<leader>/" "<cmd>FzfLua grep_visual<cr>" {desc = "Search project...";})
            (mkKeymap "n" "<leader>gg" "<cmd>Neogit<cr>" {desc = "Neogit";})
            (mkKeymap ["n" "i" "s" "x"] "<C-s>" "<cmd>w<cr><esc>" {desc = "Save File";})
            (mkKeymap "n" "<leader>qq" "<cmd>xa<cr>" {desc = "Save all and quit";})
            (mkKeymap "n" "<leader>e" "<cmd>Yazi<cr>" {desc = "Open file explorer...";})
            (mkKeymap "n" "<leader> " "<cmd>FzfLua files<cr>" {desc = "Open files...";})
            (mkKeymap ["n" "i" "s"] "<esc>" ''
                function()
                  vim.cmd('noh');
                  return '<esc>'
                end
              '' {
                desc = "Escape and Clear hlsearch";
                silent = true;
                expr = true;
                lua = true;
              })
            (mkKeymap "n" "<leader>sh" "<cmd>FzfLua helptags<cr>" {desc = "Search help";})
          ];
          binds.whichKey.enable = true;
          binds.whichKey.register = {
            "<leader>g" = "git";
            "<leader>s" = "search";
            "<leader>u" = "ui/toggle";
          };
          formatter.conform-nvim.enable = true;
          fzf-lua.enable = true;
          git.enable = true;
          languages.enableExtraDiagnostics = true;
          languages.enableFormat = true;
          languages.enableTreesitter = true;
          languages.nix.enable = true;
          languages.bash.enable = true;
          lazy.plugins = {
            neogit = {
              package = pkgs.vimPlugins.neogit;
            };
          };
          lsp.enable = true;
          lsp.formatOnSave = true;
          session.nvim-session-manager.enable = true;
          statusline.lualine.enable = true;
          theme.enable = true;
          theme.name = "dracula";
          theme.transparent = true;
          treesitter.addDefaultGrammars = true;
          treesitter.autotagHtml = true;
          treesitter.context.enable = true;
          treesitter.enable = true;
          treesitter.fold = true;
          treesitter.highlight.enable = true;
          treesitter.textobjects.enable = true;
          ui.borders.enable = true;
          utility.surround.enable = true;
          utility.yazi-nvim.enable = true;
        };
      }
    ];
  }).neovim
