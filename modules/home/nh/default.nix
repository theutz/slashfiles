{
  lib,
  config,
  pkgs,
  namespace,
  ...
}: let
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  options.${namespace}.${mod} = {
    enable = lib.mkEnableOption "enable ${mod}";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nh
      pkgs.${namespace}.swch
    ];

    home.sessionVariables = {
      NH_DARWIN_FLAKE = "/etc/nix-darwin";
    };
  };
}
