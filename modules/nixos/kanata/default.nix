{
  config,
  namespace,
  lib,
  ...
}: let
  cfg = config.${namespace}.${mod};
  mod = baseNameOf ./.;
in {
  options.${namespace}.${mod} = {
    enable = lib.mkEnableOption "enable ${mod}";
  };

  config = lib.mkIf cfg.enable {
    services.kanata = {
      enable = true;
      keyboards = {
        internalKeyboard = {
          extraDefCfg = ''
            process-unmapped-keys yes
          '';
          config = ''
            (defsrc
              caps tab d h j k l
            )
            (defvar
              tap-time 200
              hold-time 200
            )
            (defalias
              caps (tap-hold 200 200 esc lctl)
              tab (tap-hold $tap-time $hold-time tab (layer-toggle arrow))
              del del ;; alias for the true delete key action
            )
            (deflayer default
              @caps @tab d h j k l
            )
            (deflayer arrow
              _ _ @del left down up right
            )
          '';
        };
      };
    };
  };
}
