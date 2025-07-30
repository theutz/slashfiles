{
  config.vim = {
    autocomplete.blink-cmp = {
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

    mini.pairs = {
      enable = true;
      setupOpts = {
        modes = {
          insert = true;
          command = true;
          terminal = false;
        };
        skip_next = ''[[%w%%%'%[%"%.%`%$]]'';
        skip_ts = ["string"];
        skip_unbalanced = true;
        markdown = true;
      };
    };
  };
}
