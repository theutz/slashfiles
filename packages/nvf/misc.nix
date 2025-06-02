{pkgs, ...}: {
  config.vim = {
    formatter.conform-nvim.enable = true;

    git.enable = true;

    lazy.plugins = {
      neogit = {
        package = pkgs.vimPlugins.neogit;
      };
    };

    statusline.lualine.enable = true;

    ui.borders.enable = true;

    utility = {
      motion = {
        flash-nvim = {
          enable = true;
        };
      };

      surround.enable = true;

      yazi-nvim = {
        enable = true;

        mappings = {
          openYazi = "<leader>e";
          openYaziDir = null;
          yaziToggle = null;
        };

        setupOpts = {
          open_for_directories = true;
        };
      };
    };
  };
}
