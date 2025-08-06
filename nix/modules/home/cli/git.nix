{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib.${namespace}.mkMod config ./.) mkConfig;
in
{
  config = mkConfig {
    programs.git = {
      enable = true;
      aliases = {
        recommit = "!git commit -eF $(git rev-parse --git-dir/COMMIT_EDITMSG)";
      };
      ignores = [
        "Session.vim*"
        ".scratch.vim"
        ".DS_Store"
        "tinkeray.php"
        ".idea/"
        ".dir-locals.el"
        ".direnv"
        "result"
        ".mise.local.toml"
        "mise.local.toml"
      ];
      extraConfig = {
        user.name = "Michael Utz";
        user.email = "michael@theutz.com";
        user.signingkey = "F73C931E48B95546!";
        pull.rebase = true;
        rerere.enabled = true;
        rerere.autoupdate = true;
        merge.autoStash = true;
        merge.conflictStyle = "zdiff3";
        merge.tool = "vimdiff";
        rebase.autoStash = true;
        rebase.autoSquash = true;
        rebase.updateRefs = true;
        commit.gpgSign = true;
        commit.verbose = true;
        push.gpgSign = false;
        push.default = "simple";
        push.autoSetupRemote = true;
        push.followTags = true;
        tag.gpgSign = true;
        tag.sort = "version:refname";
        diff.algorithm = "histogram";
        diff.mnemonicPrefix = true;
        diff.renames = true;
        mergetool.keepBackup = false;
        mergetool.prompt = false;
        mergetool.vimdiff.cmd = ''nvim -d "''$LOCAL" "''$REMOTE" "''$MERGED" -c "wincmd l" -c "norm ]c"'';
        init.defaultBranch = "main";
        difftool.prompt = false;
        difftool.trustExitCode = true;
        submodule.fetchJobs = 4;
        github.user = "theutz";
        column.ui = "auto";
        branch.sort = "-committerdate";
        fetch.prune = true;
        fetch.pruneTags = true;
        fetch.all = true;
        help.autocorrect = "prompt";
      };
    };

    programs.git.delta = {
      enable = false;
      options = {
        features = "decorations";
        navigate = true;
        side-by-side = "false";
        interactive = {
          keep-plus-minus-markers = false;
        };
        decorations = {
          commit-decoration-style = "blue ol";
          commit-style = "raw";
          file-style = "omit";
          hunk-header-decoration-style = "blue box";
          hunk-header-style = "file line-number syntax";
        };
      };
    };

    programs.git.difftastic = {
      enable = true;
      enableAsDifftool = true;

      # Type: one of “side-by-side”, “side-by-side-show-both”, “inline”
      display = "side-by-side-show-both";
    };
  };
}
