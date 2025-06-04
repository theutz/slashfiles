{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.nvim.binds) mkKeymap;
in {
  config.vim = {
    git.enable = true;

    lazy.plugins = {
      neogit = {
        package = pkgs.vimPlugins.neogit;
      };
    };

    binds.whichKey.register."<leader>g" = "git";

    keymaps = lib.mkIf (! config.vim.terminal.toggleterm.lazygit.enable) [
      (mkKeymap ["n"] "<leader>gg"
        "<cmd>Neogit<cr>" {desc = "Neogit";})
    ];

    terminal.toggleterm = {
      enable = true;
      mappings = {
        open = "<C-/>";
      };
      lazygit = {
        enable = true;
      };
    };
  };
}
