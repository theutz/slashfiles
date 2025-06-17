{
  lib,
  config,
  namespace,
  pkgs,
  ...
}:
lib.${namespace}.mkModule {
  inherit config;
  here = ./.;
} {
  imports = [./aliases.nix];

  config = {
    home = {
      shellAliases = {
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
          "nohup.out"
        ];
        userName = "Michael Utz";
        userEmail = "michael@theutz.com";
        extraConfig = {
          pull.rebase = "true";
        };
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
              command = ''"${lib.getExe pkgs.${namespace}.comt} --staged"'';
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
