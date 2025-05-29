{lib, ...}: let
  inherit (lib.nvim.binds) mkKeymap;
in {
  config.vim = {
    binds.whichKey.enable = true;

    binds.whichKey.register = {
      "<leader>g" = "git";
      "<leader>s" = "search";
      "<leader>u" = "ui/toggle";
    };

    keymaps = [
      (mkKeymap "n" "<leader>," "<cmd>FzfLua buffers<cr>" {desc = "Open buffers...";})
      (mkKeymap "n" "<leader>/" "<cmd>FzfLua grep<cr>" {desc = "Search project...";})
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
  };
}
