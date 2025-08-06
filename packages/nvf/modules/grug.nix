{
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.nvim.binds) mkKeymap;
in
{
  config.vim = {
    keymaps = [
      (mkKeymap "n" "<leader>sR" "<cmd>GrugFar<cr>" { desc = "Search & Replace"; })
    ];

    lazy.plugins = {
      "grug-far.nvim" = {
        package = pkgs.vimPlugins.grug-far-nvim;
      };
    };
  };
}
