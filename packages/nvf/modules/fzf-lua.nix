{lib, ...}: let
  inherit (lib.nvim.binds) mkKeymap;

  searchBindings =
    lib.lists.map (
      x: {
        mode = ["n"];
        key = "<leader>s${lib.elemAt x 0}";
        action = "<cmd>FzfLua ${lib.elemAt x 1}<cr>";
        desc = lib.elemAt x 2;
      }
    ) [
      ["f" "files" "Files in project"]
      ["b" "buffers" "Open buffers"]
      ["h" "helptags" "Help files"]
      ["r" "resume" "Resume search"]
    ];
in {
  config.vim = {
    binds.whichKey.register."<leader>s" = "search";
    keymaps =
      [
        (mkKeymap ["n"] "<leader>," "<cmd>FzfLua buffers<cr>" {desc = "Open buffers...";})
        (mkKeymap ["n"] "<leader>/" "<cmd>FzfLua grep<cr><cr>" {desc = "Search in project...";})
        (mkKeymap ["n"] "<leader> " "<cmd>FzfLua files<cr>" {desc = "Open files...";})
      ]
      ++ searchBindings;

    fzf-lua = {
      enable = true;
    };
  };
}
