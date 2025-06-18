{
  lib,
  config,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) prefs;
in
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
          {
            fish = lib.getExe pkgs.fish;
            font-family = prefs.font.family;
            font-size = prefs.font.size;
            line-height = prefs.font.height;
            dark-theme = prefs.theme.dark.wezterm;
            light-theme = prefs.theme.light.wezterm;
            opacity = 0.85;
          }
          |> pkgs.replaceVars ./wezterm.lua
          |> builtins.toPath
          |> lib.fileContents;
      };
    };
  }
