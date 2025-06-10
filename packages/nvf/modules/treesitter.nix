{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.nvim.binds) mkKeymap;
  mkMove = key: dir: (mkKeymap ["n" "v"] key "<cmd>Treewalker ${dir}<cr>" {
    desc = "Treewalker move ${dir}";
    silent = true;
  });
  mkSwap = key: dir: (mkKeymap "n" key "<cmd>Treewalker Swap${dir}<cr>" {
    desc = "Treewalker swap ${dir}";
    silent = true;
  });
in {
  config.vim.lazy.plugins = {
    "treewalker.nvim" = {
      package = pkgs.vimPlugins.treewalker-nvim;
      lazy = false;
      keys = [
        (mkMove "A-h" "Left")
        (mkMove "A-j" "Down")
        (mkMove "A-k" "Up")
        (mkMove "A-l" "Right")

        (mkSwap "C-A-h" "Left")
        (mkSwap "C-A-j" "Down")
        (mkSwap "C-A-k" "Up")
        (mkSwap "C-A-l" "Right")
      ];
    };
  };

  config.vim.treesitter = {
    addDefaultGrammars = true;
    autotagHtml = true;
    context.enable = true;
    enable = true;
    fold = true;
    highlight.enable = true;
    textobjects.enable = true;
  };
}
