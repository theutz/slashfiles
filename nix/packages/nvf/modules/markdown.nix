{ lib, ... }:
{
  config.vim = {
    languages.markdown = {
      enable = true;
      extensions = {
        markview-nvim = {
          enable = true;
          setupOpts = { };
        };
      };
      extraDiagnostics.enable = true;
      format.enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };

    luaConfigRC.markdown =
      lib.nvim.dag.entryAfter [ "markview-nvim" ]
        # lua
        ''
          require('markview.extras.checkboxes').setup({})
        '';
  };
}
