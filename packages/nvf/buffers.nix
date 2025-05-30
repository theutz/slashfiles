{
  lib,
  config,
  lib',
  ...
}: let
  inherit (lib.nvim.binds) mkKeymap;
  inherit (lib.lists) optional;
  inherit (lib'.lists) flatConcat;

  mkItem = key: cmd: desc: mkKeymap ["n"] "<leader>b${key}" "<cmd>${cmd}<cr>" {inherit desc;};

  hasFzf = config.vim.fzf-lua.enable;
in {
  config.vim = {
    startPlugins = ["bufdelete-nvim"];

    binds.whichKey.register = {
      "<leader>b" = "buffers";
    };

    keymaps = flatConcat [
      [
        (mkItem "d" "Bdelete" "Delete buffer")
        (mkItem "D" "bd" "Delete buffer and close window")
        (mkItem "n" "bnext" "Next buffer")
        (mkItem "p" "bprev" "Prev buffer")
        (mkItem "b" "b #" "Most recent buffer")
      ]
      (
        optional hasFzf [
          (mkItem "s" "FzfLua buffers" "Search buffers")
        ]
      )
    ];
  };
}
