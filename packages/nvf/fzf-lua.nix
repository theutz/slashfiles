{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.nvim.binds) mkKeymap;
  cfg = config.fzf-lua;

  searchBindings =
    lib.lists.map (
      x: {
        mode = ["n"];
        key = "<leader>s${lib.elemAt x 0}";
        action = "<cmd>FzfLua ${lib.elemAt x 1}<cr>";
        desc = lib.elemAt x 2;
      }
    ) [
      ["f" "files" "Search files"]
      ["b" "buffers" "Search buffers"]
      ["h" "helptags" "Search help"]
    ];
in {
  options.fzf-lua.enable = mkEnableOption "use fzf-lua";

  config.vim = mkIf cfg.enable {
    keymaps =
      [
        (mkKeymap ["n"] "<leader>,"
          "<cmd>FzfLua buffers<cr>" {desc = "Open buffers...";})

        (mkKeymap ["n"] "<leader>/"
          "<cmd>FzfLua grep<cr>" {desc = "Search project...";})

        (mkKeymap ["n"] "<leader> "
          "<cmd>FzfLua files<cr>" {desc = "Open files...";})
      ]
      ++ searchBindings;

    fzf-lua = {
      enable = true;
    };

    session.nvim-session-manager.mappings = mkIf config.vim.session.nvim-session-manager.enable {
      deleteSession = "<leader>qx";
      loadLastSession = "<leader>ql";
      loadSession = "<leader>qf";
      saveCurrentSession = "<leader>qs";
    };
  };
}
