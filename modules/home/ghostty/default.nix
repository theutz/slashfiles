{
  lib,
  pkgs,
  config,
  namespace,
  ...
}: let
  mod = builtins.baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  options.${namespace}.${mod}.enable = lib.mkEnableOption "enable ${mod}";

  config = lib.mkIf cfg.enable {
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
        font-family = lib.${namespace}.prefs.font.family;
        font-size = lib.${namespace}.prefs.font.size;
        font-thicken = true;
        # keybind = global:shift+f13=toggle_quick_terminal
        macos-option-as-alt = "left";
        macos-titlebar-style = "transparent";
        theme = "dracula";
        window-padding-balance = true;
        window-padding-x = 8;
        window-padding-y = 2;
        window-title-font-family = lib.${namespace}.prefs.font.family;
      };
    };
  };
}
