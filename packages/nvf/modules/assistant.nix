{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.nvim.binds) mkKeymap;
  hasCodeCompanion = config.vim.assistant.codecompanion-nvim.enable;
in {
  config.vim = {
    binds.whichKey.register = lib.optionalAttrs hasCodeCompanion {
      "<leader>cl" = "LLMs";
    };

    keymaps = lib.optionals hasCodeCompanion [
      (mkKeymap "n" "<leader>clc" "<cmd>CodeCompanionChat<cr>" {desc = "Chat";})
      (mkKeymap "n" "<leader>cla" "<cmd>CodeCompanionActions<cr>" {desc = "Actions";})
      (mkKeymap "n" "<leader>clm" "<cmd>CodeCompanionCmd<cr>" {desc = "Command";})
      (mkKeymap "n" "<leader>clp" "<cmd>CodeCompanion" {desc = "Prompt";})
    ];

    assistant = {
      codecompanion-nvim = {
        enable = true;
      };
    };
  };
}
