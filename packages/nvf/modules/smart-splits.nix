{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.nvim.binds) mkKeymap;
  bind = key: func: (mkKeymap "n" key "function () require('smart-splits').${func}() end" {
    desc = func |> builtins.replaceStrings ["_"] [" "] |> lib.toSentenceCase;
    lua = true;
    silent = true;
  });
in {
  config.vim = {
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
      (bind "<C-h>" "move_cursor_left")
      (bind "<C-j>" "move_cursor_down")
      (bind "<C-k>" "move_cursor_up")
      (bind "<C-l>" "move_cursor_right")
      (bind "<A-h>" "resize_left")
      (bind "<A-j>" "resize_down")
      (bind "<A-k>" "resize_up")
      (bind "<A-l>" "resize_right")
      (bind "<C-A-h>" "swap_buf_left")
      (bind "<C-A-j>" "swap_buf_down")
      (bind "<C-A-k>" "swap_buf_up")
      (bind "<C-A-l>" "swap_buf_right")
    ];
  };
}
