{lib, ...}: let
  inherit (lib.generators) mkLuaInline;
in {
  config.vim = {
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
