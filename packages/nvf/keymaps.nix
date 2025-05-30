{lib, ...}: let
  inherit (lib.nvim.binds) mkKeymap;
in {
  config.vim = {
    binds.whichKey.enable = true;

    binds.whichKey.register = {
      "<leader>g" = "git";
      "<leader>u" = "ui/toggle";
    };

    keymaps = [
      (mkKeymap ["n"] "<leader>gg"
        "<cmd>Neogit<cr>" {desc = "Neogit";})

      (mkKeymap ["n"] "<leader>qq"
        "<cmd>xa<cr>" {desc = "Save all and quit";})

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

      (mkKeymap ["n" "i" "s" "x"] "<C-s>"
        "<cmd>w<cr><esc>" {desc = "Save File";})
    ];
  };
}
