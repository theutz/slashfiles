{
  lib,
  config,
  namespace,
  ...
}:
lib.${namespace}.mkModule {
  inherit config;
  here = ./.;
} {
  config = {
    home = {
      shellAliases = {
        gcam = "git commit --all --message";
        gcm = "git commit --message";
        gf = "git fetch";
        gfm = "git pull";
        gia = "git add";
        giaa = "git add -A";
        gid = "git diff --cached";
        gpp = "git pull && git push";
        gwd = "git diff";
        gws = "git status --short --branch";
        gwS = "git status --show-stash";
        lg = "lazygit";
      };
    };

    programs = {
      gh.enable = true;

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
        ];
        userName = "Michael Utz";
        userEmail = "michael@theutz.com";
        delta = {
          enable = true;
        };
      };

      lazygit = {
        enable = true;
        settings = {
          customCommands = [
            {
              key = "b";
              context = "files";
              command = "HK_PROFILE=ai git commit";
              description = "generate commit message with llm";
              output = "terminal";
            }
          ];
          disableStartupPopups = true;
          git = {
            commit = {
              signoff = true;
            };
            paging = {
              colorArg = "always";
              pager = ''
                delta "$(dark-mode status | grep on && echo "--dark" || echo "--light")" --paging=never
              '';
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
  };
}
