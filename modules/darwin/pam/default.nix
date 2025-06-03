{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  # mod = builtins.baseNameOf ./.;
  # cfg = config.${namespace}.${mod};
  mkMod = ns: dir: spec: let
    mod = builtins.baseNameOf dir;
    cfg = config.${ns}.${mod};
    out = spec {inherit cfg;};
  in {
    inherit (out) config;
    options.${ns}.${mod} = out.options;
  };
in
  mkMod namespace ./. ({cfg}: {
    options.enable = lib.mkEnableOption "pam security settings";

    config = lib.mkIf cfg.enable {
      environment.etc."pam.d/sudo_local".text = ''
        auth    optional        ${pkgs.pam-reattach}/lib/pam/pam_reattach.so
        auth    sufficient      pam_tid.so
      '';

      security.pam.services.sudo_local.touchIdAuth = true;
    };
  })
