{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkConfig;
in
{
  config = mkConfig {
    home.packages = with pkgs; [
      gum
    ];

    programs.fish.enable = true;

    programs.fish.functions = {
      fish_greeting =
        # fish
        ''
          gum format "# Hello

          $(date)"
        '';

      fish_user_key_bindings =
        # fish
        ''
          fish_default_key_bindings -M insert
          fish_vi_key_bindings --no-erase insert
        '';
    };
    programs.fish.shellInit =
      # fish
      ''
        fish_user_key_bindings
      '';
  };
}
