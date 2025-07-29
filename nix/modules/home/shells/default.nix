{config, lib, namespace, pkgs, ...}: let
  inherit (builtins.baseNameOf);
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};
  inherit (lib) mkIf mkEnableOption;
in {
  options.${namespace}.${mod}.enable = mkEnableOption "enable ${mod}";

  config = mkIf cfg.enable {
    programs = {
      starship = {
        enable = true;
        settings = {
          shell.disabled = false;
        };
      };

      zsh = {
        enable = true;

        prezto = {
          enable = true;
          editor.keymap = "vi";
          extraModules = ["attr" "stat"];
          pmodules = [
            "environment"
            "terminal"
            "editor"
            "history"
            "directory"
            "spectrum"
            "utility"
            "completion"
            "syntax-highlighting"
            "history-substring-search"
            "autosuggestions"
            # "prompt"
          ];
          syntaxHighlighting = {
            highlighters = [
              "main"
              "brackets"
              "pattern"
              "line"
              "cursor"
              "root"
            ];
            pattern = {
              "rm*-rf*" = "fg=white,bold,bg=red";
            };
          };
          tmux = {
            defaultSessionName = "home";
          };
        };
      };

      bash.enable = true;

      fish.enable = true;

      nushell.enable = true;
    };
  };
}
