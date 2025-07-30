{lib, ...}: let
  inherit (lib.generators) mkLuaInline;
  inherit (lib.nvim.binds) mkKeymap;
in {
  config.vim = {
    binds = {
      whichKey = {
        enable = true;
        register."<leader>u" = "ui/toggle";
        register."<leader><tab>" = "tabs";
        register."<leader>d" = "debug";
        register."<leader>dg" = "goto";
        register."<leader>dv" = "stacktrace";
        setupOpts.spec =
          mkLuaInline
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

    keymaps = let
      tabs = [
        (mkKeymap "n" "<leader><tab>l" "<cmd>tablast<cr>" {desc = "Last Tab";})
        (mkKeymap "n" "<leader><tab>o" "<cmd>tabonly<cr>" {desc = "Close Other Tabs";})
        (mkKeymap "n" "<leader><tab>f" "<cmd>tabfirst<cr>" {desc = "First Tab";})
        (mkKeymap "n" "<leader><tab><tab>" "<cmd>tabnew<cr>" {desc = "New Tab";})
        (mkKeymap "n" "<leader><tab>]" "<cmd>tabnext<cr>" {desc = "Next Tab";})
        (mkKeymap "n" "<leader><tab>d" "<cmd>tabclose<cr>" {desc = "Close Tab";})
        (mkKeymap "n" "<leader><tab>[" "<cmd>tabprevious<cr>" {desc = "Previous Tab";})
      ];
    in
      tabs
      ++ [
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
