{lib, ...}: let
  inherit (lib.nvim.binds) mkKeymap;
in {
  config.vim = {
    binds.whichKey.register."<leader>g" = "git";

    keymaps = [
      (mkKeymap ["n"] "<leader>gg"
        "<cmd>Neogit<cr>" {desc = "Neogit";})
    ];
  };
}
