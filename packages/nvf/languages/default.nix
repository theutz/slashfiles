{
  pkgs,
  ...
}:
{
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
  };
}
