{
  config.vim.binds.whichKey.register."<leader>c" = "code/lsp";
  config.vim.binds.whichKey.register."<leader>cw" = "workspace";

  config.vim.lsp = {
    enable = true;
    formatOnSave = true;
    inlayHints.enable = true;
    lightbulb.enable = true;
    lspSignature.enable = true;
    mappings = {
      addWorkspaceFolder = "<leader>cwa";
      codeAction = "<leader>ca";
      documentHighlight = "<leader>ch";
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
      openDiagnosticFloat = "<leader>cd";
      previousDiagnostic = "[d";
      removeWorkspaceFolder = "<leader>cwr";
      renameSymbol = "<leader>cr";
      signatureHelp = "gK";
      toggleFormatOnSave = "<leader>uf";
    };
  };
}
