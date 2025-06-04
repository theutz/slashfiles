{lib, ...}: {
  config = {
    vim = {
      binds = {
        whichKey = {
          register = {
            "<leader>l" = "lists";
            "<leader>c" = "code/lsp";
            "<leader>cw" = "workspace";
          };
        };
      };

      diagnostics = {
        enable = true;
        config = {
          virtual_lines = true;
          virtual_text = true;
          underline = true;
          signs = {
            text =
              lib.mapAttrs' (name: value: {
                inherit value;
                name = "vim.diagnostic.severity.${lib.toUpper name}";
              })
              {
                Error = " ";
                Warn = " ";
                Hint = " ";
                Info = " ";
              };
          };
        };
      };

      lsp = {
        enable = true;
        formatOnSave = true;
        inlayHints.enable = true;
        lightbulb.enable = true;
        lspSignature.enable = true;
        trouble = {
          enable = true;
          mappings = {
            documentDiagnostics = "<leader>ld";
            locList = "<leader>ll";
            lspReferences = "<leader>lr";
            quickfix = "<leader>lq";
            symbols = "<leader>ls";
            workspaceDiagnostics = "<leader>lw";
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
  };
}
