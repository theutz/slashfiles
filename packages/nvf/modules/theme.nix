{
  lib,
  lib',
  ...
}: {
  config.vim.theme = rec {
    enable = true;

    name = lib'.prefs.theme.dark.nvf;

    style = lib.attrByPath [name] null {
      catppuccin = "mocha";
      rose-pine = "main"; # main, moon, dawn (only sets the dark_variant)
    };

    transparent = lib.traceValSeq (lib.attrByPath [name] true {
      rose-pine = false;
    });
  };
}
