{lib, ...}: let
  inherit (lib.nvim.binds) mkKeymap;
in {
  config.vim = {
    startPlugins = ["bufdelete-nvim"];

    binds.whichKey.register = {
      "<leader>b" = "buffers";
    };

    keymaps = [
      (mkKeymap ["n"] "<leader>bd"
        "<cmd>Bdelete<cr>" {desc = "Delete buffer";})
    ];
  };
}
