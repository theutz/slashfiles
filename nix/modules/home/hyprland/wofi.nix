{
  config,
  lib,
  ...
}: let
  inherit (lib.slashfiles.mkMod config ./.) mkConfig;
  inherit (lib.slashfiles) font rose-pine;
  rp = rose-pine.hex "main";
in {
  config = mkConfig {
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
          :root {
            font-size: ${toString font.size}px;
          }

          window {
            margin: 1rem;
            border: 0.25rem solid ${rp "pine"};
            background-color: ${rp "base"};
            color: ${rp "text"};
            border-radius: 1rem;
            font-family: ${font.family};
            font-size: 1rem;
          }

          #inner-box {}

          #outer-box {
            padding: 1rem;
          }

          #input {
            border: none;
            background-color: ${rp "surface"};
            color: ${rp "text"};
            margin-bottom: 1rem;
          }

          #input:focus {
            outline: ${rp "pine"};
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
