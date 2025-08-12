{
  lib,
  config,
  lib',
  ...
}:
let
  inherit (lib.nvim.binds) mkKeymap;
  inherit (lib.lists) optional;
  inherit (lib') flatConcat;

  mkItem =
    key: cmd: desc:
    mkKeymap [ "n" ] "<leader>b${key}" "<cmd>${cmd}<cr>" { inherit desc; };

  hasFzf = config.vim.fzf-lua.enable;
  hasBufferline = config.vim.tabline.nvimBufferline.enable == true;
in
{
  config.vim = {
    binds.whichKey.register = {
      "<leader>b" = "buffers";
    };

    tabline.nvimBufferline = {
      enable = true;
      mappings = {
        closeCurrent = "<leader>bd";
        cycleNext = "<leader>bn";
        cyclePrevious = "<leader>bp";
        pick = "<leader>bc";
      };

      setupOpts.options = {
        numbers = "none";
        close_command = "Bdelete %d";
      };
    };

    keymaps =
      [
        [
          (mkItem "b" "b #" "Most recent buffer")
          (mkItem "o" "BufferLineCloseOthers" "Close others")
          (mkItem "k" "BufferLineTogglePin" "Pin buffer")
        ]
        (optional hasFzf [
          (mkItem "s" "FzfLua buffers" "Search buffers")
        ])
        [
          (mkKeymap "n" "]b" (if hasBufferline then "<cmd>BufferLineCycleNext<cr>" else "<cmd>bnext<cr>") {
            desc = "Next buffer";
          })
          (mkKeymap "n" "[b" (if hasBufferline then "<cmd>BufferLineCyclePrev<cr>" else "<cmd>bprev<cr>") {
            desc = "Previous buffer";
          })
        ]
      ]
      |> lib.concatLists
      |> lib.flatten;
  };
}
