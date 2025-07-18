{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  cfg = config.${namespace}.${mod};
  mod = baseNameOf ./.;
in {
  options.${namespace}.${mod} = {
    enable = lib.mkEnableOption "enable ${mod}";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gawkInteractive
      macchina
      countryfetch
      tinyfetch
      nerdfetch
    ];

    programs.fish = {
      enable = true;
      functions = {
        fish_greeting = ''
          set greetings \
            macchina \
            "countryfetch --list-countries | awk '{print \$3}' | shuf | head -n 1 | xargs countryfetch" \
            tinyfetch \
            nerdfetch
          eval $greetings[(random 1 (count $greetings))]
        '';

        fish_user_key_bindings = ''
          fish_default_key_bindings -M insert
          fish_vi_key_bindings --no-erase insert
        '';
      };
      shellInit =
        # fish
        ''
          fish_user_key_bindings
        '';
    };
  };
}
