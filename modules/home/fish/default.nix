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
      macchina
    ];

    programs.fish = {
      enable = true;
      functions = {
        fish_greeting = ''
          macchina
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
