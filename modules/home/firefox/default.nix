{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.)
    mkMod
    ;

  bookmarks = [
    {
      name = "Nix";
      toolbar = true;
      bookmarks = [
        {
          name = "Searchix";
          url = "https://searchix.ovh";
          tags = [ "nix" ];
        }
        {
          name = "Noogle";
          url = "https://noogle.dev";
          tags = [ "nix" ];
        }
      ];
    }
  ];

  settings = {
    "browser.aboutConfig.showWarning" = false;
    "browser.startup.homepage" = "https://kagi.com";
    "startup.homepage_override_url" = "https://kagi.com";
    "browser.warnOnQuit" = false;
  };

  extensions = {
    force = true;
    packages = with pkgs.nur.repos.rycee.firefox-addons; [
      profile-switcher
      onepassword-password-manager
      consent-o-matic
      tridactyl
      ublock-origin
      sponsorblock
      kagi-search
      raindropio
    ];
  };
in
mkMod {
  home.packages = with pkgs; [
  ];

  home.shellAliases = lib.optionalAttrs pkgs.stdenv.isDarwin {
    firefox = "open -a Firefox";
    firefox-work = "open -a Firefox --args -P 'work'";
  };

  programs.firefox = {
    enable = true;

    package = pkgs.firefox.override {
      nativeMessagingHosts = [ pkgs.tridactyl-native ];
    };

    nativeMessagingHosts = with pkgs; [
      tridactyl-native
    ];

    profiles = {
      default = {
        inherit settings extensions;

        isDefault = true;
        id = 0;
        bookmarks = {
          force = true;
          settings = bookmarks ++ [ ];
        };
      };

      work = {
        inherit settings extensions;
        id = 1;
        bookmarks = {
          force = true;
          settings = bookmarks ++ [ ];
        };
      };
    };
  };
}
