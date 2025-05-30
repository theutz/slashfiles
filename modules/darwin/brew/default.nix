{
  pkgs,
  lib,
  config,
  ...
}: let
  mod = "brew";
in {
  options.${mod} = {
    enable = lib.mkEnableOption "defaults for managing homebrew";
  };

  # config = lib.mkIf cfg.enable {
  # homebrew.brews = import ./brew
  config = {
    environment.systemPackages = with pkgs; [
      onefetch
    ];
  };
}
