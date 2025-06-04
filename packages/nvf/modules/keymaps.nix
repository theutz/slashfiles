{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.nvim.binds) mkKeymap;
in {
  config.vim = {
    binds = {
      whichKey = {
        enable = true;
        register."<leader>u" = "ui/toggle";
        setupOpts.spec =
          lib.generators.mkLuaInline
          # lua
          ''
            {
              {
                mode = { "n", "v" },
                {
                  "<leader>b",
                  group = "buffer",
                  expand = function()
                    return require("which-key.extras").expand.buf()
                  end,
                },
                {
                  "<leader>w",
                  group = "windows",
                  proxy = "<c-w>",
                  expand = function()
                    return require("which-key.extras").expand.win()
                  end,
                },
              },
            }
          '';
      };
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
    ];
  };
}
