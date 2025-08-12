{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkMod;
in
mkMod {
  programs.neovide = {
    enable = true;
    settings = {
      frame = "transparent";
      maximized = false;
      title-hidden = false;

      font =
        let
          inherit (lib.${namespace}.font) family;
        in
        {
          normal = {
            inherit family;
            style = "Regular";
          };
          bold = {
            inherit family;
            style = "Bold";
          };
          size = 14;
        };
    };
  };
}
