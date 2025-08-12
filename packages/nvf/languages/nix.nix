{
  config.vim.languages = {
    nix.enable = true;
    nix.extraDiagnostics.enable = true;
    nix.extraDiagnostics.types = [ "deadnix" ];
    nix.format.enable = true;
    nix.format.type = "nixfmt";
    nix.lsp.enable = true;
    nix.treesitter.enable = true;
  };
}
