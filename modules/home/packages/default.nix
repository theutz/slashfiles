{
  pkgs,
  namespace,
  config,
  lib,
  inputs,
  ...
}: let
  inherit (builtins) baseNameOf;
  inherit (lib) mkIf mkEnableOption;
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  options.${namespace}.${mod} = {
    enable = mkEnableOption "Default packages";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        comma
        zoom-us
        coreutils
        fd
        lazygit
        procs
        ripgrep
        aichat
        signal-desktop-bin
        spotify-player
      ]
      ++ (with nerd-fonts; [
        roboto-mono
        blex-mono
      ]);
  };
}
