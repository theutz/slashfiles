{ lib, ... }:
{

  config.vim = {
    binds = {
      whichKey = {
        register = {
          "<leader>l" = "lists";
          "<leader>c" = "code/lsp";
          "<leader>cw" = "workspace";
          "<leader>v" = "vim";
        };
      };
    };

    diagnostics = {
      enable = true;
      config = {
        virtual_lines = false;
        virtual_text = false;
        underline = true;
        update_in_insert = true;
        signs.text =
          lib.generators.mkLuaInline
            # lua
            ''
              {
                [vim.diagnostic.severity.ERROR] = " ",
                [vim.diagnostic.severity.WARN] = " ",
                [vim.diagnostic.severity.HINT] = " ",
                [vim.diagnostic.severity.INFO] = " "
              }
            '';
      };
    };

    lsp = {
      enable = true;
      formatOnSave = true;
      inlayHints.enable = true;
      # lightbulb.enable = true;
      trouble = {
        enable = true;
        mappings = {
          documentDiagnostics = "<leader>xd";
          locList = "<leader>xl";
          lspReferences = "<leader>xr";
          quickfix = "<leader>xq";
          symbols = "<leader>xs";
          workspaceDiagnostics = "<leader>xw";
        };
      };

      mappings = {
        addWorkspaceFolder = "<leader>cwa";
        codeAction = "<leader>ca";
        documentHighlight = "<leader>cH";
        format = "<leader>cf";
        goToDeclaration = "gD";
        goToDefinition = "gd";
        goToType = "gy";
        hover = "K";
        listDocumentSymbols = "<leader>cs";
        listImplementations = "<leader>ci";
        listReferences = "gr";
        listWorkspaceFolders = "<leader>cwf";
        listWorkspaceSymbols = "<leader>cws";
        nextDiagnostic = "]d";
        openDiagnosticFloat = "<leader>ch";
        previousDiagnostic = "[d";
        removeWorkspaceFolder = "<leader>cwr";
        renameSymbol = "<leader>cr";
        signatureHelp = "gK";
        toggleFormatOnSave = "<leader>uf";
      };
    };
  };

}
