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
      ["b" "buffers" "Open buffers..."]
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

        (mkKeymap ["n"] "<leader>sh"
          "<cmd>FzfLua helptags<cr>" {desc = "Search help";})
      ]
      ++ searchBindings;

    fzf-lua = {
      enable = true;
    };
  };
}
