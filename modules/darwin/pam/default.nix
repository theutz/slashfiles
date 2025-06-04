{
  pkgs,
  lib,
  config,
  namespace,
  ...
}:
lib.${namespace}.mkModule {
  inherit config;
  here = ./.;
} {
  config = {
    environment.etc."pam.d/sudo_local".text = ''
      auth    optional        ${pkgs.pam-reattach}/lib/pam/pam_reattach.so
      auth    sufficient      pam_tid.so
    '';

    security.pam.services.sudo_local.touchIdAuth = true;
  };
}
