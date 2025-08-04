{ ... }:
{
  programs = {
    git = {
      enable = true;
      ignores = [
        "*~"
        "*.swp"
        "*.log"
        ".direnv"
        "Session.vim*"
        ".DS_Store"
        ".idea/"
        ".dir-locals.el"
        "result"
        ".mise.local.toml"
        "mise.local.toml"
        "nohup.out"
      ];
      userName = "Michael Utz";
      userEmail = "michael@theutz.com";
      extraConfig = {
        push.autoSetupRemote = "true";
        pull.rebase = "true";
        init.defaultBranch = "main";
      };

      delta.enable = true;
    };

    gh.enable = true;

    lazygit = {
      enable = true;

      settings = {
        disableStartupPopups = true;
        git = {
          commit = {
            signoff = true;
          };
          paging = {
            colorArg = "always";
            parseEmoji = true;
            overrideGpg = true;
          };
        };
        gui = {
          border = "rounded";
          expandFocusedSidePanel = true;
          nerdFontsVersion = "3";
          showBottomLine = false;
          showCommandLog = true;
          showRandomTip = false;
        };
        notARepository = "skip";
        promptToReturnFromSubprocess = false;
      };
    };
  };

  home.shellAliases = {
    lg = "lazygit";
  };
}
