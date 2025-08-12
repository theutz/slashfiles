{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkConfig;
in
{
  config = mkConfig {
    home.packages =
      with pkgs;
      [
        ffmpeg
        _7zz
        jq
        poppler
        fd
        ripgrep
        fzf
        zoxide
        imagemagick
        resvg
      ]
      ++ (lib.optionals pkgs.stdenv.isLinux [
        wl-clipboard
      ]);

    programs.yazi = {
      enable = true;
      shellWrapperName = "y";
    };
  };
}
