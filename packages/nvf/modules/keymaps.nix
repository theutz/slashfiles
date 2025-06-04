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
      };
    };

    extraPlugins = {
      "smart-splits.nvim" = {
        package = pkgs.vimPlugins.smart-splits-nvim;
        setup =
          # lua
          ''
            require('smart-splits').setup()
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
      (mkKeymap "n" "<leader>wq" "<cmd>wq<cr>" {desc = "Close window";})

      (mkKeymap "n" "<C-h>" "function() require('smart-splits').move_cursor_left() end" {
        desc = "Move cursor left";
        lua = true;
      })
      (mkKeymap "n" "<C-j>" "function() require('smart-splits').move_cursor_down() end" {
        desc = "Move cursor down";
        lua = true;
      })
      (mkKeymap "n" "<C-k>" "function() require('smart-splits').move_cursor_up() end" {
        desc = "Move cursor up";
        lua = true;
      })
      (mkKeymap "n" "<C-l>" "function() require('smart-splits').move_cursor_right() end" {
        desc = "Move cursor right";
        lua = true;
      })
      (mkKeymap "n" "<A-h>" "function() require('smart-splits').resize_left() end" {
        desc = "Resize left";
        lua = true;
      })
      (mkKeymap "n" "<A-j>" "function() require('smart-splits').resize_down() end" {
        desc = "Resize down";
        lua = true;
      })
      (mkKeymap "n" "<A-k>" "function() require('smart-splits').resize_up() end" {
        desc = "Resize up";
        lua = true;
      })
      (mkKeymap "n" "<A-l>" "function() require('smart-splits').resize_right() end" {
        desc = "Resize right";
        lua = true;
      })
      (mkKeymap "n" "<C-A-h>" "function() require('smart-splits').swap_buf_left({ move_cursor = true }) end" {
        desc = "Swap buffer left";
        lua = true;
      })
      (mkKeymap "n" "<C-A-j>" "function() require('smart-splits').swap_buf_down({ move_cursor = true }) end" {
        desc = "Swap buffer down";
        lua = true;
      })
      (mkKeymap "n" "<C-A-k>" "function() require('smart-splits').swap_buf_up({ move_cursor = true }) end" {
        desc = "Swap buffer up";
        lua = true;
      })
      (mkKeymap "n" "<C-A-l>" "function() require('smart-splits').swap_buf_right({ move_cursor = true }) end" {
        desc = "Swap buffer right";
        lua = true;
      })
    ];
  };
}
