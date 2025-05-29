{
  pkgs,
  lib,
  nvf',
  ...
}:
(nvf'.lib.neovimConfiguration {
  inherit pkgs;

  modules = [
    {
      config.vim = {
        diagnostics.enable = true;
        diagnostics.config.virtual_lines = true;
        diagnostics.config.virtual_text = true;
        diagnostics.config.underline = true;
        formatter.conform-nvim.enable = true;
        fzf-lua.enable = true;
        git.enable = true;
        languages.enableExtraDiagnostics = true;
        languages.enableFormat = true;
        languages.enableTreesitter = true;
        languages.nix.enable = true;
        languages.bash.enable = true;
        lazy.plugins = {
          neogit = {
            package = pkgs.vimPlugins.neogit;
          };
        };
        lsp.enable = true;
        lsp.formatOnSave = true;
        lsp.inlayHints.enable = true;
        lsp.lightbulb.enable = true;
        lsp.lspSignature.enable = true;
        session.nvim-session-manager.enable = true;
        statusline.lualine.enable = true;
        theme.enable = true;
        theme.name = "dracula";
        theme.transparent = true;
        ui.borders.enable = true;
        utility.surround.enable = true;
        utility.yazi-nvim.enable = true;
      };
    }
    ./keymaps.nix
  ];
}).neovim
