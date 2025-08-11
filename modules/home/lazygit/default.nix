{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkMod;
in
mkMod {
  home.shellAliases = {
    lg = "lazygit";
  };

  programs.lazygit.enable = true;

  programs.lazygit.settings = {
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
}
