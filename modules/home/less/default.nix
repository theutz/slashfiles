{
  lib,
  config,
  namespace,
  ...
}: let
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  options.${namespace}.${mod} = {
    enable = lib.mkEnableOption "enable less for paging";
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      LESS = ''-g -i -M -R -S -w -X -z-4'';
    };

    programs.tmux.extraConfig = ''
      set -ga update-environment LESS
    '';

    programs = {
      less = {
        enable = true;
        keys = ''
          zl	right-scroll
          zh	left-scroll
        '';
      };

      lesspipe.enable = true;
    };
  };
}
