{
  lib,
  pkgs,
  config,
  ...
}:
lib.slashfiles.mkModule {
  inherit config;
  here = ./.;
} {
  config = {
    programs.ghostty = {
      enable = true;
      package =
        if pkgs.stdenv.hostPlatform.isDarwin
        then null
        else pkgs.ghostty;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      settings = {
        adjust-cell-height = 16;
        background-opacity = 0.75;
        font-family = "RobotoMono Nerd Font Propo";
        font-size = 16;
        font-thicken = true;
        # keybind = global:shift+f13=toggle_quick_terminal
        macos-option-as-alt = "left";
        macos-titlebar-style = "transparent";
        theme = "dracula";
        window-padding-balance = true;
        window-padding-x = 8;
        window-padding-y = 2;
        window-title-font-family = "RobotoMono Nerd Font Propo";
      };
    };
  };
}
