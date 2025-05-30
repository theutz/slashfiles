{
  lib,
  config,
  ...
}: let
  inherit (lib.nvim.binds) mkKeymap;
  inherit (lib.lists) optional;

  mkItem = key: cmd: desc: mkKeymap ["n"] "<leader>b${key}" "<cmd>${cmd}<cr>" {inherit desc;};
in {
  config.vim = {
    startPlugins = ["bufdelete-nvim"];

    binds.whichKey.register = {
      "<leader>b" = "buffers";
    };

    keymaps = lib.pipe [
      [
        (mkItem "d" "Bdelete" "Delete buffer")
        (mkItem "n" "bnext" "Next buffer")
        (mkItem "p" "bprev" "Prev buffer")
        (mkItem "l" "b #" "Most recent buffer")
      ]
      (
        optional config.vim.fzf-lua.enable
        (mkItem "b" "FzfLua buffers" "Search buffers")
      )
    ] [lib.concatLists lib.flatten];
  };
}
