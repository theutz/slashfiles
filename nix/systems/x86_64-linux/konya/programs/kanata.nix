{
  services.kanata.enable = true;
  services.kanata.keyboards = {
    internalKeyboard = {
      extraDefCfg = ''
        process-unmapped-keys yes
      '';

      config = ''
        (defsrc
          caps tab d h j k l
          lmeta lalt
        )

        (defvar
          tap-time 200
          hold-time 200
        )

        (defalias
          caps (tap-hold-press 100 200 esc lctl)
          tab (tap-hold-press $tap-time $hold-time tab (layer-toggle arrow))
          del del ;; alias for the true delete key action
        )

        (deflayer default
          @caps @tab d h j k l
          lalt lmeta
        )

        (deflayer arrow
          _ _ @del left down up right
          _ _
        )
      '';
    };
  };
}
