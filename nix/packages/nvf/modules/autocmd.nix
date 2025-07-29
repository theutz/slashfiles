{lib, ...}: {
  config.vim = let
    inherit (lib.generators) mkLuaInline;
  in rec {
    augroups =
      lib.map
      (cmd: {name = cmd.group;})
      autocmds;

    autocmds = [
      {
        group = "resize_splits";
        event = ["VimResized"];
        callback =
          mkLuaInline
          # lua
          ''
            function()
              local current_tab = vim.fn.tabpagenr()
              vim.cmd("tabdo wincmd =")
              vim.cmd("tabnext " .. current_tab)
            end
          '';
      }

      {
        group = "highlight_yank";
        event = ["TextYankPost"];
        callback =
          mkLuaInline
          # lua
          ''
            function()
              (vim.hl or vim.highlight).on_yank()
            end
          '';
      }

      {
        group = "autosave";
        event = ["BufLeave" "FocusLost"];
        command = "silent! wall";
        desc = "Save on focus lost";
        pattern = ["*"];
      }

      {
        group = "checktime";
        event = ["FocusGained" "TermClose" "TermLeave"];
        callback =
          mkLuaInline
          # lua
          ''
            function()
              if vim.o.buftype ~= "nofile" then
                vim.cmd("checktime")
              end
            end
          '';
      }

      {
        group = "last_loc";
        event = ["BufReadPost"];
        callback =
          mkLuaInline
          # lua
          ''
            function(event)
              local exclude = { "gitcommit" }
              local buf = event.buf
              if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
                return
              end
              vim.b[buf].lazyvim_last_loc = true
              local mark = vim.api.nvim_buf_get_mark(buf, '"')
              local lcount = vim.api.nvim_buf_line_count(buf)
              if mark[1] > 0 and mark[1] <= lcount then
                pcall(vim.api.nvim_win_set_cursor, 0, mark)
              end
            end
          '';
      }

      {
        group = "close_with_q";
        pattern = [
          "PlenaryTestPopup"
          "checkhealth"
          "dbout"
          "gitsigns-blame"
          "grug-far"
          "help"
          "lspinfo"
          "neotest-output"
          "neotest-output-panel"
          "neotest-summary"
          "notify"
          "qf"
          "spectre_panel"
          "startuptime"
          "tsplayground"
        ];
        event = ["FileType"];
        callback =
          mkLuaInline
          # lua
          ''
            function(event)
              vim.bo[event.buf].buflisted = false
              vim.schedule(function()
                vim.keymap.set("n", "q", function()
                  vim.cmd("close")
                  pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
                end, {
                  buffer = event.buf,
                  silent = true,
                  desc = "Quit buffer",
                })
              end)
            end
          '';
      }
    ];
  };
}
