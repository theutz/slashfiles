{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.binds) mkKeymap;
  cfg = config.fzf-lua;
in {
  options.fzf-lua.enable = mkEnableOption "use fzf-lua";
  config.vim = mkIf cfg.enable {
    keymaps = [
      (mkKeymap ["n"] "<leader>,"
        "<cmd>FzfLua buffers<cr>" {desc = "Open buffers...";})

      (mkKeymap ["n"] "<leader>/"
        "<cmd>FzfLua grep<cr>" {desc = "Search project...";})

      (mkKeymap ["n"] "<leader> "
        "<cmd>FzfLua files<cr>" {desc = "Open files...";})

      (mkKeymap ["n"] "<leader>sh"
        "<cmd>FzfLua helptags<cr>" {desc = "Search help";})
    ];

    fzf-lua = {
      enable = true;
    };
  };
}
