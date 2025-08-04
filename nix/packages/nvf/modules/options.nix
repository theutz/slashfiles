{ lib, ... }:
let
  inherit (lib.generators) mkLuaInline;
in
{
  config.vim = {
    globals = {
      mapleader = " ";
      maplocalleader = ",";
      autoformat = true;
      markdown_recommended_style = 0;
    };

    options = {
      autowrite = true;
      clipboard = "unnamedplus";
      conceallevel = 2;
      confirm = true;
      cursorline = true;
      expandtab = true;
      fillchars = lib.strings.concatMapAttrsStringSep "," (name: value: "${name}:${value}") {
        foldopen = "";
        foldclose = "";
        fold = " ";
        foldsep = " ";
        diff = "╱";
        eob = " ";
      };

      foldlevel = 99;
      formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()";
      formatoptions = "jcroqlnt";
      grepformat = "%f:%l:%c:%m";
      grepprg = "rg --vimgrep";
      ignorecase = true;
      inccommand = "nosplit";
      jumpoptions = "view";
      laststatus = 3;
      linebreak = true;
      list = true;
      mouse = "a";
      number = true;
      pumblend = 10;
      pumheight = 10;
      relativenumber = true;
      ruler = false;
      scrolloff = 4;
      sessionoptions = lib.strings.concatStringsSep "," [
        "buffers"
        "curdir"
        "tabpages"
        "winsize"
        "help"
        "globals"
        "skiprtp"
        "folds"
      ];
      shiftround = true;
      shiftwidth = 2;
      shortmess =
        mkLuaInline
          # lua
          ''
            vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
          '';
      showmode = false;
      sidescrolloff = 8;
      signcolumn = "yes";
      smartcase = true;
      smartindent = true;
      spelllang = "en";
      splitbelow = true;
      splitkeep = "screen";
      splitright = true;
      tabstop = 2;
      termguicolors = true;
      timeoutlen =
        mkLuaInline
          # lua
          ''vim.g.vscode and 1000 or 300'';
      undofile = true;
      undolevels = 10000;
      updatetime = 200;
      virtualedit = "block";
      wildmode = "longest:full,full";
      winminwidth = 5;
      wrap = false;
      smoothscroll = true;
      foldmethod = "expr";
      foldtext = "";
    };
  };
}
