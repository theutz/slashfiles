{
  lib,
  lib',
  ...
}: let
  inherit (lib') prefs;

  name =
    {
      rose-pine = "rose-pine";
      rose-pine-dawn = "rose-pine";
      rose-pine-moon = "rose-pine";
    }
    |> lib.getAttr prefs.theme.main;

  style =
    {
      rose-pine = "main";
      rose-pine-dawn = "dawn";
      rose-pine-moon = "moon";
    }
    |> lib.getAttr prefs.theme.main;

  transparent =
    {
      rose-pine = false;
      rose-pine-dawn = false;
      rose-pine-moon = false;
    }
    |> lib.getAttr prefs.theme.main;
in {
  config.vim.theme = {
    enable = true;
    inherit name style transparent;
  };
}
