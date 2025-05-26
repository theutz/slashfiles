{ config, pkgs, lib, ... }: {
        home = {
                activation = {
                        reloadTmux = lib.hm.dag.entryAfter ["writeBoundary"] /* bash */ ''
                                export TERM="xterm-256color"
                                tmux="${lib.getExe pkgs.tmux}"
                                file="${lib.concatStringsSep "/" [config.xdg.configHome "tmux" "tmux.conf"]}"

                                echo "Reloading tmux..."
                                if
                                        run "$tmux" source-file "$file"
                                then
                                        echo "Tmux config reloaded!"
                                        run "$tmux" display-message -d 5000 "Config reloaded by nix-darwin!"
                                else
                                        echo "ERROR: Could not reload tmux config."
                                        run "$tmux" display-message -d 5000 "Failed to reload config!"
                                fi
                        '';
                };
                preferXdgDirectories = true;
                shell = {
                        # Enables in all shells
                        enableShellIntegration = true;
                };
	        stateVersion = "25.05";
        };
        programs = {
                bash = {
                        enable = true;
                };
                fish = {
                        enable = true;
                };
                home-manager = {
                        enable = true;
                };
                nushell = {
                        enable = true;
                };
                nvf = {
                        enable = true;
                        enableManpages = true;
                        settings = {
                                vim = {
                                        binds = {
                                                whichKey = {
                                                        enable = true;
                                                };
                                        };
                                        fzf-lua = {
                                                enable = true;
                                        };
                                        languages = {
                                                nix = {
                                                        enable = true;
                                                };
                                        };
                                        lsp = {
                                                enable = true;
                                        };
                                        keymaps = let
                                                inherit (lib.nvf.nvim.binds) mkKeymap;
                                        in [
                                                (mkKeymap ["n" "i"] "C-s" ":w<cr>" { desc= "Save current file"; })
                                                (mkKeymap "n" "<leader>qq" ":xa<cr>" { desc = "Save all and quit."; })
                                                (mkKeymap "n" "<cmd>Oil<cr>" "<leader>e" { desc = "Open file explorer"; })
                                                (mkKeymap "n" "<cmd>FzfLua files<cr>" "<leader> " { desc = "Open files..."; })
                                        ];
                                        session = {
                                                nvim-session-manager = {
                                                        enable = true;
                                                };
                                        };
                                        statusline = {
                                                lualine = {
                                                        enable = true;
                                                };
                                        };
                                        theme = {
                                                name = "dracula";
                                                transparent = true;
                                        };
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
                                        ui = {
                                                borders = {
                                                        enable = true;
                                                };
                                        };
                                        utility = {
                                                oil-nvim = {
                                                        enable = true;
                                                };
                                                surround = {
                                                        enable = true;
                                                };
                                                yazi-nvim = {
                                                        enable = true;
                                                };
                                        };
                                        viAlias = true;
                                        vimAlias = true;
                                };
                        };
                };
                starship = {
                        enable = true;
                };
                tmux = {
                        aggressiveResize = true;
                        baseIndex = 1;
                        clock24 = true;
                        customPaneNavigationAndResize = true;
                        enable = true;
                        escapeTime = 0;
                        extraConfig = /* tmux */ ''
                                set -g allow-passthrough on
                                set -g allow-rename on
                                set -g default-command "${lib.getExe pkgs.fish}"
                                set -g default-terminal "xterm-256color"
                                set -g extended-keys always
                                set -g terminal-overrides ",xterm*:Tc"
                                set -ga update-environment TERM
                                set -ga update-environment TERM_PROGRAM
                        '';
                        focusEvents = true;
                        keyMode = "vi";
                        mouse = true;
                        plugins = with pkgs; [
                                tmuxPlugins.sessionist
                                tmuxPlugins.pain-control
                                tmuxPlugins.dracula
                        ];
                        prefix = "M-m";
                };
                yazi = {
                        enable = true;
                        enableBashIntegration = true;
                        enableFishIntegration = true;
                        enableZshIntegration = true;
                        enableNushellIntegration = true;
                };
                zoxide = {
                        enable = true;
                        enableBashIntegration = true;
                        enableFishIntegration = true;
                        enableZshIntegration = true;
                };
        };
        xdg = {
                enable = true;
                configFile = {
                        "ghostty/config".source = ./ghostty-config;
                };
        };
}
