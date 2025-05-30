{lib, ...}: let
  inherit (lib.nvim.binds) mkKeymap;
in {
  config.vim = {
    startPlugins = ["bufdelete-nvim"];

    binds.whichKey.enable = true;

    binds.whichKey.register = {
      "<leader>g" = "git";
      "<leader>s" = "search";
      "<leader>u" = "ui/toggle";
      "<leader>b" = "buffers";
    };

    keymaps = [
      (mkKeymap ["n"] "<leader>bd"
        "<cmd>Bdelete<cr>" {desc = "Delete buffer";})

      (mkKeymap ["n"] "<leader>gg"
        "<cmd>Neogit<cr>" {desc = "Neogit";})

      (mkKeymap ["n"] "<leader>qq"
        "<cmd>xa<cr>" {desc = "Save all and quit";})

      (mkKeymap ["n"] "<leader>e"
        "<cmd>Yazi<cr>" {desc = "Open file explorer...";})

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
