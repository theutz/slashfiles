{
  pkgs,
  lib,
  config,
  namespace,
  ...
}:
lib.${namespace}.modules.mkModule {
  inherit config;
  here = ./.;
} ({cfg}: {
  options.enable = lib.mkEnableOption "pam security settings";

  config = lib.mkIf cfg.enable {
    environment.etc."pam.d/sudo_local".text = ''
      auth    optional        ${pkgs.pam-reattach}/lib/pam/pam_reattach.so
      auth    sufficient      pam_tid.so
    '';

    security.pam.services.sudo_local.touchIdAuth = true;
  };
})
