{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.nvim.binds) mkKeymap;
in {
  config.vim = {
    git = {
      enable = false;

      git-conflict = {
        enable = true;
        mappings = {
          both = "<leader>gcb";
          nextConflict = "<leader>gcn";
          prevConflict = "<leader>gcp";
          none = "<leader>gc0";
          ours = "<leader>gco";
          theirs = "<leader>gct";
        };
      };

      gitsigns = {
        enable = true;
        mappings = {
          blameLine = "<leader>gb";
          diffProject = "<leader>gdD";
          diffThis = "<leader>gdd";
          nextHunk = "]c";
          previewHunk = "<leader>ghP";
          previousHunk = "[c";
          resetBuffer = "<leader>ghR";
          resetHunk = "<leader>ghr";
          stageBuffer = "<leader>ghS";
          stageHunk = "<leader>ghs";
          toggleBlame = "<leader>ub";
          toggleDeleted = null;
          undoStageHunk = "<leader>ghu";
        };
      };
    };

    lazy.plugins = {
      neogit = {
        package = pkgs.vimPlugins.neogit;
      };
    };

    binds.whichKey.register = {
      "<leader>g" = "git";
      "<leader>gc" = "conflict";
      "<leader>gh" = "hunk";
      "<leader>gd" = "diff";
    };

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
