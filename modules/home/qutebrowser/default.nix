{
  config,
  lib,
  namespace,
  ...
}: let
  mod = builtins.baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  options.${namespace}.${mod}.enable = lib.mkEnableOption "enable ${mod}";

  config = lib.mkIf cfg.enable {
    programs.qutebrowser = {
      enable = true;

      searchEngines = let
        kagi = "https://kagi.com/search?q={}";
        wikipedia = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
      in {
        inherit kagi wikipedia;
        "DEFAULT" = kagi;
        k = kagi;
        w = wikipedia;
        nw = "https://wiki.nixos.org/index.php?search={}";
        g = "https://www.google.com/search?hl=en&q={}";
      };

      settings = {
        url = {
          default_page = "http://localhost:42286";
          open_base_url = true;
        };
      };
    };
  };
}
