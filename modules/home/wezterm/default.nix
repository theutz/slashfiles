{
  lib,
  config,
  pkgs,
  ...
}:
lib.slashfiles.mkModule {
  inherit config;
  here = ./.;
}
{
  config = {
    programs.wezterm = {
      enable = true;

      enableBashIntegration = true;
      enableZshIntegration = true;

      extraConfig =
        pkgs.replaceVars ./wezterm.lua {
          fish = lib.getExe pkgs.fish;
          font-family = lib.slashfiles.prefs.font.family;
          font-size = lib.slashfiles.prefs.font.size;
          line-height = lib.slashfiles.prefs.font.height;
        }
        |> builtins.toPath
        |> lib.fileContents;
    };
  };
}
