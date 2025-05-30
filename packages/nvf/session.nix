{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.generators) mkLuaInline;
  name = "session";
  cfg = config.${name};
in {
  options.${name}.enable = mkEnableOption "Manage neovim sesions";

  config.vim = mkIf cfg.enable {
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
