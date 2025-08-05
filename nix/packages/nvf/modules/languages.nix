{pkgs, ...}: {
  config.vim.lazy.plugins = {
    # FIXME: Find out why this isn't working
    # "vimplugin-treesitter-grammar-jinja" = {
    #   package = pkgs.vimPlugins.nvim-treesitter-parsers.jinja;
    # };
    "jinja.vim" = {
      package = pkgs.vimPlugins.jinja-vim;
    };
  };
  config.vim.languages = {
    enableDAP = true;
    enableExtraDiagnostics = true;
    enableFormat = true;
    enableTreesitter = true;

    bash.enable = true;
    bash.extraDiagnostics.enable = true;
    bash.format.enable = true;
    bash.lsp.enable = true;
    bash.treesitter.enable = true;

    css.enable = true;
    css.format.enable = true;
    css.format.type = "prettierd";
    css.lsp.enable = true;
    css.treesitter.enable = true;

    go.enable = true;
    go.dap.enable = true;
    go.format.enable = true;
    go.lsp.enable = true;
    go.treesitter.enable = true;

    html.enable = true;
    html.treesitter.enable = true;

    lua.enable = true;
    lua.extraDiagnostics.enable = true;
    lua.format.enable = true;
    lua.lsp.enable = true;
    lua.lsp.lazydev.enable = true;
    lua.treesitter.enable = true;

    nix.enable = true;
    nix.extraDiagnostics.enable = true;
    nix.extraDiagnostics.types = ["deadnix"];
    nix.format.enable = true;
    nix.format.type = "nixfmt";
    nix.lsp.enable = true;
    nix.treesitter.enable = true;

    nu.enable = true;
    nu.lsp.enable = true;
    nu.treesitter.enable = true;

    php.enable = true;
    php.lsp.enable = true;
    php.treesitter.enable = true;

    python.enable = true;
    python.dap.enable = true;
    python.format.enable = true;
    python.lsp.enable = true;
    python.treesitter.enable = true;

    ruby.enable = true;
    ruby.extraDiagnostics.enable = true;
    ruby.format.enable = true;
    ruby.lsp.enable = true;
    ruby.treesitter.enable = true;

    rust.enable = true;
    rust.crates.enable = true;
    rust.dap.enable = true;
    rust.format.enable = true;
    rust.lsp.enable = true;
    rust.treesitter.enable = true;

    sql.enable = true;
    sql.extraDiagnostics.enable = true;
    sql.format.enable = true;
    sql.lsp.enable = true;
    sql.treesitter.enable = true;

    ts.enable = true;
    ts.extensions.ts-error-translator.enable = true;
    ts.extraDiagnostics.enable = true;
    ts.format.enable = true;
    ts.format.type = "prettierd";
    ts.lsp.enable = true;
    ts.treesitter.enable = true;

    yaml.enable = true;
    yaml.lsp.enable = true;
    yaml.treesitter.enable = true;
  };
}
