{ config, pkgs, lib, ... }: {
        home = {
                activation = {
                        reloadTmux = let
                                tmux = lib.getExe pkgs.tmux;
                                file = lib.concatStringsSep "/" [config.xdg.configHome "tmux" "tmux.conf"];
                        in lib.hm.dag.entryAfter ["writeBoundary"] /* bash */ ''
                                export TERM="xterm-256color"
                                if
                                        run ${tmux} ls &>/dev/null
                                then
                                        verboseEcho "Reloading tmux..."
                                        if
                                                run ${tmux} source-file "${file}"
                                        then
                                                verboseEcho "Tmux config reloaded!"
                                                run ${tmux} display-message -d 5000 "Config reloaded by nix-darwin!" &!
                                        else
                                                echo "ERROR: Could not reload tmux config."
                                                run ${tmux} display-message -d 5000 "Failed to reload config!" &!
                                        fi
                                else
                                        verboseEcho "No tmux running"
                                fi

                        '';
                };
                packages = with pkgs; [
                        delta
                ];
                preferXdgDirectories = true;
                shell = {
                        # Enables in all shells
                        enableShellIntegration = true;
                };
                shellAliases = {
                        lg = "lazygit";
                };
	        stateVersion = "25.05";
        };
        programs = {
                bat = {
                        enable = true;
                        config = {
                                theme = "Dracula";
                        };
                };
                bash = {
                        enable = true;
                };
                eza = {
                        enable = true;
                        enableBashIntegration = true;
                        enableZshIntegration = true;
                        enableFishIntegration = true;
                        enableNushellIntegration = true;
                };
                fish = {
                        enable = true;
                };
                ghostty = {
                        enable = true;
                        package = if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.ghostty;
                        enableBashIntegration = true;
                        enableZshIntegration = true;
                        enableFishIntegration = true;
                };
                git = {
                        delta = {
                                enable = true;
                        };
                };
                home-manager = {
                        enable = true;
                };
                lazygit = {
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
                        # customPaneNavigationAndResize = true;
                        enable = true;
                        escapeTime = 0;
                        extraConfig = /* tmux */ ''
                                set -g allow-passthrough on
                                set -g allow-rename on
                                set -g default-command "${lib.getExe pkgs.fish}"
                                set -g default-terminal "xterm-256color"
                                set -g extended-keys always
                                set -g terminal-overrides ",xterm*:Tc"
                                set -sa terminal-features "xterm*:extkeys"
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
                wezterm = {
                        enable = true;
                        enableBashIntegration = true;
                        enableZshIntegration = true;
                        extraConfig = let
                                fish = lib.getExe pkgs.fish;
                        in /* lua */ ''
                                local config = wezterm.config_builder()

                                config.font_size = 16
                                config.color_scheme = "Dracula"
                                config.default_prog = { "${fish}" }
                                -- For compatibility with mprocs https://github.com/pvolok/mprocs/issues/165
                                -- config.enable_csi_u_key_encoding = true
                                return config
                        '';
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
                        enableNushellIntegration = true;
                };
                zsh = {
                        enable = true;
                };
        };
        xdg = {
                enable = true;
                configFile = {
                        "ghostty/config".source = ./ghostty-config;
                };
        };
}
