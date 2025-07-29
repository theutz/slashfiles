{ config, pkgs, namespace, lib, ... }: let
  inherit (builtins) baseNameOf;
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};
  inherit (lib) mkIf mkEnableOption;
  inherit (config.lib.file) mkOutOfStoreSymlink;
in {
  options.${namespace}.${mod}.enable = mkEnableOption "enable ${mod}";

  config = mkIf cfg.enable {
    programs.neovim.enable = true;
    programs.neovim.defaultEditor = true;
    programs.neovim.viAlias = true;
    programs.neovim.vimAlias = true;
    programs.neovim.vimdiffAlias = true;

    home.packages = with pkgs; [
      gcc
      lazygit
      ripgrep
      fd
      fzf
    ];

    xdg.configFile."nvim" = {
      source = mkOutOfStoreSymlink "/etc/nixos/nix/modules/home/lazyvim/nvim";
      force = true;
      recursive = false;
    };
  };
}

