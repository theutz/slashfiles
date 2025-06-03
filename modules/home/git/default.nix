{
  lib,
  config,
  namespace,
  ...
}:
lib.${namespace}.mkModule {
  inherit config;
  here = ./.;
} ({cfg}: {
  options.enable = lib.mkEnableOption "git-based tool options";

  config = lib.mkIf cfg.enable {
    home.shellAliases.lg = "lazygit";

    programs.gh.enable = true;

    programs.git = {
      enable = true;
      ignores = ["*~" "*.swp" "*.log" ".direnv"];
      userName = "Michael Utz";
      userEmail = "michael@theutz.com";
      delta = {
        enable = true;
      };
    };

    programs.lazygit = {
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
})
