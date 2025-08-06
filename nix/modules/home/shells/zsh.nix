{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.mkMod config ./.) mkConfig;
in
{
  config = mkConfig {
    programs.zsh.enable = true;

    sops.secrets =
      let
        sopsFile = lib.snowfall.fs.get-file "secrets/api-keys.yaml";
      in
      {
        gh_token = { inherit sopsFile; };
      };

    programs.zsh.envExtra = ''
      export GH_TOKEN=''$(<${config.sops.secrets.gh_token.path})
    '';

    programs.zsh.prezto.enable = true;

    programs.zsh.prezto.editor.keymap = "vi";

    programs.zsh.prezto.extraModules = [
      "attr"
      "stat"
    ];

    programs.zsh.prezto.pmodules = [
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

    programs.zsh.prezto.syntaxHighlighting.highlighters = [
      "main"
      "brackets"
      "pattern"
      "line"
      "cursor"
      "root"
    ];

    programs.zsh.prezto.syntaxHighlighting.pattern = {
      "rm*-rf*" = "fg=white,bold,bg=red";
    };

    programs.zsh.prezto.tmux = {
      defaultSessionName = "home";
    };
  };
}
