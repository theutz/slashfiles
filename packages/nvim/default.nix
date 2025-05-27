{ lib, inputs, namespace, pkgs, stdenv, ... }: (lib.nvf.neovimConfiguration {
        inherit pkgs;

        modules = [
                {
                        config.vim = {
                                keymaps = let
                                        inherit (lib.nvf.nvim.binds) mkKeymap;
                                        normal = key: action: desc: mkKeymap "n" key action { inherit desc; };
                                in [
                                        (normal "<leader>," "<cmd>FzfLua buffers<cr>" "Open buffers...")
                                        (normal "<leader>/" "<cmd>FzfLua grep_visual<cr>" "Search project...")
                                        (mkKeymap ["n" "i"] "C-s" ":w<cr>" { desc= "Save current file"; })
                                        (mkKeymap "n" "<leader>qq" ":xa<cr>" { desc = "Save all and quit."; })
                                        (mkKeymap "n" "<leader>e" "<cmd>Oil<cr>" { desc = "Open file explorer"; })
                                        (mkKeymap "n" "<leader> " "<cmd>FzfLua files<cr>" { desc = "Open files..."; })
                                        (mkKeymap "n" "<esc><esc>" "<cmd>nohlsearch<bar>diffupdate<bar>normal! <C-l><cr>" { desc = "Clear search highlighting"; silent = true; })
                                ];
                                binds.whichKey.enable = true;
                                fzf-lua.enable = true;
                                languages.enableExtraDiagnostics = true;
                                languages.enableFormat = true;
                                languages.enableTreesitter = true;
                                languages.nix.enable = true;
                                languages.bash.enable = true;
                                lsp.enable = true;
                                session.nvim-session-manager.enable = true;
                                statusline.lualine.enable = true;
                                theme.enable = true;
                                theme.name = "dracula";
                                theme.transparent = true;
                                treesitter.addDefaultGrammars = true;
                                treesitter.autotagHtml = true;
                                treesitter.context.enable = true;
                                treesitter.enable = true;
                                treesitter.fold = true;
                                treesitter.highlight.enable = true;
                                treesitter.textobjects.enable = true;
                                ui.borders.enable = true;
                                utility.oil-nvim.enable = true;
                                utility.surround.enable = true;
                                utility.yazi-nvim.enable = true;
                        };
                }
        ];
}).neovim
