{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (builtins) baseNameOf;
  inherit (lib) mkIf mkEnableOption;
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  options.${namespace}.${mod}.enable = mkEnableOption "enable ${mod}";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      brightnessctl
    ];

    programs.bat = {
      enable = true;

      config = {
        theme = "rose-pine";
      };

      extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
        batgrep
        batwatch
      ];

      syntaxes = {
        tmux = {
          src = pkgs.fetchFromGitHub {
            owner = "gerardroche";
            repo = "sublime-tmux";
            rev = "c7c6891698b752d5c6050929e4896bb8caa608ae";
            hash = "sha256-c7WJOmrYi8MLCU19O8KGNfV7YxSO+SdVmxtwsdkIxtQ=";
          };
          file = "Tmux.sublime-syntax";
        };
      };

      themes = let
        src = pkgs.fetchFromGitHub {
          owner = "rose-pine";
          repo = "tm-theme";
          rev = "c4cab0c431f55a3c4f9897407b7bdad363bbb862";
          sha256 = "sha256-maQp4QTJOlK24eid7mUsoS7kc8P0gerKcbvNaxO8Mic=";
        };
      in {
        rose-pine = {
          inherit src;
          file = "dist/themes/rose-pine.tmTheme";
        };
        rose-pine-dawn = {
          inherit src;
          file = "dist/themes/rose-pine-dawn.tmTheme";
        };
        rose-pine-moon = {
          inherit src;
          file = "dist/themes/rose-pine-moon.tmTheme";
        };
      };
    };

    programs.fd.enable = true;
    programs.ripgrep.enable = true;
  };
}
