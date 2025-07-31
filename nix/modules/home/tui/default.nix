{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) baseNameOf;
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};
  inherit (lib) mkIf mkEnableOption;
in {
  imports = [
    ./audio.nix
    ./bluetooth.nix
  ];

  options.${namespace}.${mod}.enable = mkEnableOption "enable ${mod}";

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      aggressiveResize = true;
      baseIndex = 1;
      clock24 = true;
      customPaneNavigationAndResize = true;
      disableConfirmationPrompt = true;
      escapeTime = 10;
      extraConfig = ''
      '';
      focusEvents = true;
      historyLimit = 100000;
      keyMode = "vi";
      mouse = true;
      newSession = false;
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = rose-pine;
          extraConfig = ''
            set -g @rose_pine_variant 'main'
          '';
        }
        {
          plugin = resurrect;
          extraConfig = ''
            set -g @resurrect-strategy-nvim 'session'
          '';
        }
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '5' # minutes
          '';
        }
        pain-control
      ];
      prefix = "M-m";
      reverseSplit = false;
      sensibleOnTop = true;
      terminal = "xterm-256color";
      tmuxp = {
        enable = true;
      };
    };
  };
}
