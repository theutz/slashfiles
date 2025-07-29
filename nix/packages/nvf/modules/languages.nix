{pkgs, ...}: {
  config.vim.lazy.plugins = {
    "vimplugin-treesitter-grammar-jinja" = {
      package = pkgs.vimPlugins.nvim-treesitter-parsers.jinja;
    };
    "jinja.vim" = {
      package = pkgs.vimPlugins.jinja-vim;
    };
  };
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
      format = {
        enable = true;
        type = "prettierd";
      };
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

    nix = {
      enable = true;
      extraDiagnostics = {
        enable = true;
        types = ["deadnix"];
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
      format = {
        enable = true;
        type = "prettierd";
      };
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
