{lib, ...}: let
  inherit (lib.nvim.binds) mkKeymap;
in {
  config.vim = {
    binds.whichKey.enable = true;

    binds.whichKey.register = {
      "<leader>u" = "ui/toggle";
    };

    keymaps = [
      (
        mkKeymap ["n" "i" "s"] "<esc>"
        # lua
        ''
          function() vim.cmd('noh'); return '<esc>' end
        ''
        {
          desc = "Escape and Clear hlsearch";
          silent = true;
          expr = true;
          lua = true;
        }
      )

      (mkKeymap ["n" "i" "s" "x"] "<C-s>" "<cmd>w<cr><esc>" {desc = "Save File";})
      (mkKeymap "n" "<leader>wd" "<cmd>wq<cr>" {desc = "Close window";})
      (mkKeymap "n" "<leader>wq" "<cmd>wq<cr>" {desc = "Close window";})
    ];
  };
}
