{
  config,
  lib,
  pkgs,
  ...
}: let
  mod = baseNameOf ./.;
  cfg = config.programs.${mod};
in {
  options.programs.${mod}.enable = lib.mkEnableOption "enable ${mod} file tree diff viewer";

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      home.packages = with pkgs; [
        slashfiles.ftdv
      ];
    }
    (lib.mkIf config.programs.tealdeer.enable {
      xdg.dataFile."tealdeer/pages/ftdv.page.md".source = ./tldr.md;
    })
  ]);
}
