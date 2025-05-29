{
  config.vim.binds.whichKey.register."<leader>l" = "lsp";

  config.vim.lsp = {
    enable = true;
    formatOnSave = true;
    inlayHints.enable = true;
    lightbulb.enable = true;
    lspSignature.enable = true;
  };
}
