{ lib, ... }:
let
  inherit (lib.nvim.binds) mkKeymap;

  searchBindings =
    lib.lists.map
      (x: {
        mode = [ "n" ];
        key = "<leader>s${lib.elemAt x 0}";
        action = "<cmd>FzfLua ${lib.elemAt x 1}<cr>";
        desc = lib.elemAt x 2;
      })
      [
        [
          "b"
          "blines"
          "Open buffers"
        ]

        [
          "B"
          "lines"
          "Lines in open buffers"
        ]

        [
          "ca"
          "lsp_code_actions"
          "Code Actions"
        ]
        [
          "cd"
          "lsp_definitions"
          "Definitions"
        ]
        [
          "cD"
          "lsp_declarations"
          "Declarations"
        ]
        [
          "ct"
          "lsp_typedefs"
          "Type definitions"
        ]
        [
          "ci"
          "lsp_implementations"
          "Implementations"
        ]
        [
          "cr"
          "lsp_references"
          "References"
        ]
        [
          "cs"
          "lsp_document_symbols"
          "Symbols (document)"
        ]
        [
          "cS"
          "lsp_workspace_symbols"
          "Symbols (workspace)"
        ]
        [
          "cx"
          "lsp_diagnostics_document"
          "Diagnostics (document)"
        ]
        [
          "cX"
          "lsp_diagnostics_workspace"
          "Diagnostics (workspace)"
        ]

        [
          "d"
          "zoxide"
          "Zoxide recents"
        ]

        [
          "f"
          "files"
          "Files in project"
        ]
        [
          "F"
          "oldfiles"
          "Recent files"
        ]

        [
          "gb"
          "git_branches"
          "Git branches"
        ]
        [
          "gC"
          "git_bcommits"
          "Git commits (buffer)"
        ]
        [
          "gc"
          "git_commits"
          "Git commits (project)"
        ]
        [
          "gd"
          "git_diff"
          "Git diff"
        ]
        [
          "gf"
          "git_files"
          "Git files"
        ]
        [
          "gh"
          "git_hunks"
          "Git hunks"
        ]
        [
          "gl"
          "git_blame"
          "Git blame"
        ]
        [
          "gp"
          "git_stash"
          "Git stash"
        ]
        [
          "gs"
          "git_status"
          "Git status"
        ]
        [
          "gt"
          "git_tags"
          "Git tags"
        ]

        [
          "h"
          "helptags"
          "Help files"
        ]

        [
          "j"
          "jumps"
          "Jumps"
        ]

        [
          "k"
          "keymaps"
          "Keymaps"
        ]

        [
          "m"
          "manpages"
          "Manpages"
        ]

        [
          "q"
          "quickfix"
          "Files in quickfix"
        ]

        [
          "r"
          "resume"
          "Resume search"
        ]

        [
          "s"
          "treesitter"
          "Current buffer treesitter symbols"
        ]

        [
          "t"
          "tabs"
          "Tabs"
        ]

        [
          "v"
          "commands"
          "Vim commands"
        ]
        [
          "V"
          "command_history"
          "Vim command history"
        ]

        [
          "z"
          "builtins"
          "FzfLua builtins"
        ]

        [
          "'"
          "marks"
          "Marks"
        ]
        [
          ''"''
          "registers"
          "Registers"
        ]
      ];
in
{
  config.vim = {
    binds = {
      whichKey = {
        register = {
          "<leader>s" = "search";
          "<leader>sg" = "git";
          "<leader>sc" = "code/lsp";
        };
      };
    };
    keymaps = [
      (mkKeymap "n" "<leader>," "<cmd>FzfLua buffers<cr>" { desc = "Open buffers..."; })
      (mkKeymap "n" "<leader>/" "<cmd>FzfLua grep<cr>" { desc = "Search in project..."; })
      (mkKeymap "n" "<leader><space>" "<cmd>FzfLua files<cr>" { desc = "Open files..."; })
    ]
    ++ searchBindings;

    fzf-lua = {
      enable = true;
    };
  };
}
