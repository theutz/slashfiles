{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  mod = builtins.baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  options.${namespace}.${mod} = {
    enable = lib.mkEnableOption "pam security settings";
  };

  config = lib.mkIf cfg.enable {
    environment.etc."pam.d/sudo_local".text = ''
      auth    optional        ${pkgs.pam-reattach}/lib/pam/pam_reattach.so
      auth    sufficient      pam_tid.so
    '';
    security.pam.services.sudo_local.touchIdAuth = true;
  };
}
