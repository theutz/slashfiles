{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.${namespace}.mkMod config ./.) mkConfig;
in
{
  config = mkConfig {
    home.packages = with pkgs; [
      fd
      tree
    ];

    programs.fzf = {
      enable = true;
      tmux.enableShellIntegration = true;

      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
      defaultCommand = "fd --type f";

      fileWidgetOptions = [ "--preview 'head {}'" ];
    };
  };
}
