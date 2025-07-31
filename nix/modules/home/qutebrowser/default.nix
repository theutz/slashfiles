{
  namespace,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) baseNameOf;
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};
  inherit (lib) mkIf mkEnableOption;
  inherit (config.lib.file) mkOutOfStoreSymlink;
in {
  options.${namespace}.${mod}.enable = mkEnableOption "enable ${mod}";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      qutebrowser
    ];

    xdg.configFile."qutebrowser" = {
      source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${namespace}/nix/modules/home/qutebrowser/personal";
      recursive = true;
    };

    xdg.configFile."qutebrowser-work/config" = {
      source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${namespace}/nix/modules/home/qutebrowser/work";
      recursive = true;
    };
  };
}
