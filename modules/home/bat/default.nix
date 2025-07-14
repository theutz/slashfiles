{
  pkgs,
  namespace,
  lib,
  config,
  ...
}: let
  themes = rec {
    rose-pine = "ansi";
    rose-pine-moon = rose-pine;
    rose-pine-dawn = rose-pine;
  };
  inherit (lib.${namespace}.prefs.theme) main;
  theme = lib.getAttr main themes;
  mod = builtins.baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  options.${namespace}.${mod}.enable = lib.mkEnableOption "enable ${mod}";
  config = lib.mkIf cfg.enable {
    home.shellAliases = {
      cat = "bat";
    };

    programs.bat = {
      enable = true;

      config = {
        inherit theme;
      };

      extraPackages = with pkgs.bat-extras; [batman batwatch batdiff batgrep];

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
    };
  };
}
