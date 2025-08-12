{ nil_ls, ... }:
{
  config.vim.languages = {
    nix.enable = true;
    nix.extraDiagnostics.enable = true;
    nix.extraDiagnostics.types = [ "deadnix" ];
    nix.format.enable = true;
    nix.format.type = "nixfmt";
    nix.lsp.enable = true;
    nix.lsp.package = nil_ls;
    nix.treesitter.enable = true;
  };
}
