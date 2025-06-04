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
        }
        |> builtins.toPath
        |> lib.fileContents;
    };
  };
}
