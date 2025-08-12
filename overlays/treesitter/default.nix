{ channels, lib, ... }:
_: prev:
lib.recursiveUpdate prev {
  vimPlugins.nvim-treesitter-parsers = prev.vimPlugins.nvim-treesitter-parsers // {
    inherit (channels.unstable.vimPlugins.nvim-treesitter-parsers) nu;
  };
}
