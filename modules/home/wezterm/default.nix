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
        }
        |> builtins.toPath
        |> lib.fileContents;
    };
  };
}
