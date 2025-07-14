{
  lib,
  config,
  namespace,
  ...
}: let
  mod = builtins.baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  options.${namespace}.${mod}.enable = lib.mkEnableOption "enable ${mod}";

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      DIRENV_LOG_FORMAT = ""; # Quiet!
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
