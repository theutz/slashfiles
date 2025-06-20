{
  pkgs,
  lib,
  config,
  ...
}:
lib.slashfiles.mkModule {
  inherit config;
  here = ./.;
} {
  config = {
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
          # set -a greetings (
          #   "macchina"
          #   "countryfetch --list-countries | awk '{print $3}' | shuf | head -n 1 | xargs countryfetch"
          #   "tinyfetch"
          #   "nerdfetch"
          # )
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
