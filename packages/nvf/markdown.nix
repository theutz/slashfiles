{ lib, ... }:
{
  config.vim = {
    languages.markdown = {
      enable = true;
      extensions = {
        markview-nvim = {
          enable = true;
          setupOpts = { };
        };
      };
      extraDiagnostics.enable = true;
      format.enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };

    luaConfigRC.markdown =
      lib.nvim.dag.entryAfter [ "markview-nvim" ]
        # lua
        ''
          require('markview.extras.checkboxes').setup({})
          vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
            group = vim.api.nvim_create_augroup('markview bindings', { clear = true }),
            pattern = {"*.md", "*.markdown"},
            desc = "Add markview bindings",
            callback = function()
              vim.api.nvim_buf_set_keymap(
                0,
                "n",
                "<localleader>x",
                "<cmd>Checkbox toggle<cr>",
                { desc = "Cycle checkbox state" }
              )
              vim.api.nvim_buf_set_keymap(
                0,
                "n",
                "<localleader>c",
                "<cmd>Checkbox interactive<cr>",
                { desc = "Change checkbox state (interactive)" }
              )
            end
          })
        '';
  };
}
