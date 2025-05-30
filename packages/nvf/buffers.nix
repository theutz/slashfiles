{lib, ...}: let
  inherit (lib.nvim.binds) mkKeymap;

  mkItem = key: cmd: desc: mkKeymap ["n"] "<leader>b${key}" "<cmd>${cmd}<cr>" {inherit desc;};
in {
  config.vim = {
    startPlugins = ["bufdelete-nvim"];

    binds.whichKey.register = {
      "<leader>b" = "buffers";
    };

    keymaps = [
      (mkItem "d" "Bdelete" "Delete buffer")
      (mkItem "n" "bnext" "Next buffer")
    ];
  };
}
