{
  osConfig,
  pkgs,
  lib,
  namespace,
  ...
}: {
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
