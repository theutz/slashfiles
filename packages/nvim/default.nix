{ lib, inputs, namespace, pkgs, stdenv, ... }: (lib.nvf.neovimConfiguration {
        inherit pkgs;
        modules = [
                {
                        config.vim = {
                                binds.whichKey.enable = true;
                                languages.enableExtraDiagnostics = true;
                                languages.enableFormat = true;
                                languages.enableTreesitter = true;
                                languages.nix.enable = true;
                                lsp.enable = true;
                                theme.enable = true;
                                fzf-lua.enable = true;
                                keymaps = let
                                        inherit (lib.nvf.nvim.binds) mkKeymap;
                                in [
                                        (mkKeymap "n" "<leader>," "<cmd>FzfLua buffers<cr>" {desc="Open buffers...";})
                                        (mkKeymap ["n" "i"] "C-s" ":w<cr>" { desc= "Save current file"; })
                                        (mkKeymap "n" "<leader>qq" ":xa<cr>" { desc = "Save all and quit."; })
                                        (mkKeymap "n" "<leader>e" "<cmd>Oil<cr>" { desc = "Open file explorer"; })
                                        (mkKeymap "n" "<leader> " "<cmd>FzfLua files<cr>" { desc = "Open files..."; })
                                        (mkKeymap "n" "<esc><esc>" "<cmd>nohlsearch<bar>diffupdate<bar>normal! <C-l><cr>" { desc = "Clear search highlighting"; silent = true; })
                                ];
                                session = {
                                        nvim-session-manager = {
                                                enable = true;
                                        };
                                };
                                statusline.lualine.enable = true;
                                theme.name = "dracula";
                                theme.transparent = true;
                                treesitter = {
                                        enable = true;
                                        addDefaultGrammars = true;
                                        autotagHtml = true;
                                        context = {
                                                enable = true;
                                        };
                                        fold = true;
                                        highlight = {
                                                enable = true;
                                        };
                                        textobjects = {
                                                enable = true;
                                        };
                                };
                                ui.borders.enable = true;
                                utility.oil-nvim.enable = true;
                                utility.surround.enable = true;
                                utility.yazi-nvim.enable = true;
                        };
                }
        ];
}).neovim
