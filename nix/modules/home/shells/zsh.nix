{
  config,
  lib,
  ...
}: let
  inherit (lib.slashfiles.mkMod config ./.) mkConfig;
in {
  config = mkConfig {
    programs.zsh = {
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
  };
}
