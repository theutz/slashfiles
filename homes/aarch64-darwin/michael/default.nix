{ ... }: {
        programs = {
                home-manager.enable = true;

                nvf = {
                        enable = true;

                        enableManpages = true;
                        # defaultEditor = true;

                        settings = {
                                vim = {
                                        viAlias = true;
                                        vimAlias = true;
                                        lsp = {
                                                enable = true;
                                        };
                                        statusline = {
                                                lualine = {
                                                        enable = true;
                                                };
                                        };
                                };
                        };
                };

                zoxide = {
                        enable = true;
                        enableBashIntegration = true;
                        enableFishIntegration = true;
                        enableZshIntegration = true;
                };
        };

	home.stateVersion = "25.05";
}
