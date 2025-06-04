{
  config.vim.autocomplete = {
    blink-cmp = {
      enable = true;
      mappings = {
        close = "<C-e>";
        complete = "<C-space>";
        confirm = "<C-y>";
        next = "<C-n>";
        previous = "<C-p>";
        scrollDocsDown = "<C-d>";
        scrollDocsUp = "<C-u>";
      };
      setupOpts = {
        signature.enabled = true;
      };
    };
  };
}
