{lib, ...}: let
  inherit (lib.generators) mkLuaInline;
  inherit (lib.nvim.binds) mkKeymap;
in {
  config.vim = {
    keymaps = [
      (mkKeymap ["n"] "<leader>qq" "<cmd>xa<cr>" {desc = "Save all and quit";})
    ];
    binds.whichKey.register."<leader>q" = "quit/session";

    session.nvim-session-manager = {
      enable = true;

      mappings = {
        deleteSession = "<leader>qx";
        loadLastSession = "<leader>ql";
        loadSession = "<leader>qf";
        saveCurrentSession = "<leader>qs";
      };

      setupOpts.autoload_mode = mkLuaInline "sm.AutoloadMode.GitSession";
    };
  };
}
