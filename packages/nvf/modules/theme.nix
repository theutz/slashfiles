{lib, ...}: {
  config.vim.theme = rec {
    enable = true;
    name = "rose-pine";
    style = lib.attrByPath [name] null {
      catppuccin = "mocha";
      rose-pine = "main"; # auto, main, moon, dawn
    };
    transparent = true;
  };
}
