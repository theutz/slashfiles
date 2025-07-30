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
  imports = [
    ./bat.nix
  ];

  options.${namespace}.${mod}.enable = mkEnableOption "enable ${mod}";

  config = mkIf cfg.enable {
    home.packages = with pkgs; (lib.concatLists [
      (lib.optionals pkgs.stdenv.isLinux [])
    ]);

    programs.fd.enable = true;
    programs.ripgrep.enable = true;
  };
}
