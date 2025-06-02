{
  config.vim.languages = {
    enableDAP = true;
    enableExtraDiagnostics = true;
    enableFormat = true;
    enableTreesitter = true;

    bash = {
      enable = true;
      extraDiagnostics.enable = true;
      format.enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };

    css = {
      enable = true;
      format.enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };

    go = {
      enable = true;
      dap.enable = true;
      format.enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };

    html = {
      enable = true;
      dap.enable = true;
      extraDiagnostics.enable = true;
      format.enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };

    lua = {
      enable = true;
      extraDiagnostics.enable = true;
      format.enable = true;
      lsp.enable = true;
      lsp.lazydev.enable = true;
      treesitter.enable = true;
    };

    markdown = {
      enable = true;
      extendions = {
        markview-nvim.enable = true;
      };
      extraDiagnostics.enable = true;
      format.enable = true;
      lsp.enable = true;
      treesitter = true;
    };

    nix = {
      enable = true;
      extraDiagnostics = {
        enable = true;
        types = ["statix" "deadnix"];
      };
      format.enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };

    nu = {
      enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };

    php = {
      enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };

    python = {
      enable = true;
      dap.enable = true;
      format.enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };

    ruby = {
      enable = true;
      extraDiagnostics.enable = true;
      format.enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };

    rust = {
      enable = true;
      crates.enable = true;
      dap.enable = true;
      format.enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };

    sql = {
      enable = true;
      extraDiagnostics.enable = true;
      format.enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };

    ts = {
      enable = true;
      extensions = {ts-error-translator.enable = true;};
      extraDiagnostics.enable = true;
      format.enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };

    yaml = {
      enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };
  };
}
