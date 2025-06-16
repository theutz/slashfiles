{
  osConfig,
  pkgs,
  lib,
  namespace,
  ...
}: {
  imports = [./karabiner ./spotify-player];

  slashfiles =
    ../../../modules/home
    |> lib.filesystem.listFilesRecursive
    |> lib.map (builtins.dirOf)
    |> lib.unique
    |> lib.filter (lib.filesystem.pathIsDirectory)
    |> lib.map (builtins.baseNameOf)
    |> lib.slashfiles.enableByPath;

  home = {
    sessionPath = [
      osConfig.homebrew.brewPrefix
    ];

    sessionVariables = {
      MANPAGER = "${lib.getExe pkgs.${namespace}.nvf} -c +Man!";
      MANWIDTH = 999;
    };

    shell = {
      # Enables in all shells
      enableShellIntegration = true;
    };

    stateVersion = "25.05";
  };

  programs = {
    home-manager = {
      enable = true;
    };
  };
}
