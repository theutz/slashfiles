{
  pkgs,
  lib,
  config,
  ...
}: let
  mod = "brew";
  cfg = config.${mod};
in {
  options.${mod} = {
    enable = lib.mkEnableOption "defaults for managing homebrew";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      onefetch
    ];
  };
}
