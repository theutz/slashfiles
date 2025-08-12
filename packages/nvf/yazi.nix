{
  config.vim = {
    utility.yazi-nvim = {
      enable = true;

      mappings = {
        openYazi = "<leader>e";
        openYaziDir = null;
        yaziToggle = null;
      };

      setupOpts = {
        open_for_directories = true;
        keymaps = {
          grep_in_directory = false;
          replace_in_directory = false;
          open_file_in_horizontal_split = "<c-s>";
          change_working_directory = "<c-g>";
        };
      };
    };
  };
}
