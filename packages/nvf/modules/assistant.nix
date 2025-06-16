{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.nvim.binds) mkKeymap;
in {
  config.vim = {
    keymaps = lib.optionals config.vim.assistant.codecompanion-nvim.enable [
      (mkKeymap "n" "<leader>clc" "<cmd>CodeCompanionChat<cr>" {desc = "Chat";})
    ];

    assistant = {
      codecompanion-nvim = {
        enable = true;
      };
    };
  };
}
