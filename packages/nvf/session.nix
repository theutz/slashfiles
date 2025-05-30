{
  config,
  lib,
  ...
}: {
  options.session.enable = lib.mkEnableOption "Manage neovim sesions";

  config.vim = lib.mkIf config.session.enable {
    session = {
      nvim-session-manager = {
        enable = true;
        mappings = {
          deleteSession = "<leader>qx";
          loadLastSession = "<leader>ql";
          loadSession = "<leader>qf";
          saveCurrentSession = "<leader>qs";
        };
        setupOpts = {
          autoload_mode = lib.generators.mkLuaInline "sm.AutoloadMode.GitSession";
        };
      };
    };
  };
}
