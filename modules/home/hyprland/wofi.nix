{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: let
  mod = builtins.baseNameOf ./.;
  cfg = config.${namespace}.${mod};

  rp = lib.${namespace}.rose-pine.hex "main";
  inherit (lib.${namespace}.prefs) font;
in {
  config = lib.mkIf cfg.enable {
    programs.wofi = {
      enable = true;
      settings = {
        key_up = "Ctrl-k";
        key_down = "Ctrl-j";
        key_left = "Ctrl-h";
        key_right = "Ctrl-l";
        key_forward = "Ctrl-n";
        key_backward = "Ctrl-p";
        key_pgup = "Ctrl-u";
        key_pgdn = "Ctrl-d";
        key_expand = "Ctrl-o";
      };
      style =
        # css
        ''
          window {
            margin: 5px;
            border: 1px solid ${rp "pine"};
            background-color: ${rp "base"};
            color: ${rp "text"};
            border-radius: 10px;
            font-family: ${font.family};
            font-size: ${font.size |> toString}px;
          }

          #entry:selected {
            background-color: ${rp "gold"};
            color: ${rp "base"};
          }

          #text:selected {
            color: ${rp "base"};
          }
        '';
    };
  };
}
