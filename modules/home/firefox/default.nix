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

  settings = {
    "browser.aboutConfig.showWarning" = false;
    "browser.startup.homepage" = "https://kagi.com";
    "startup.homepage_override_url" = "https://kagi.com";
    "browser.sessionstore.resume_session_once" = true;
    "browser.sessionstore.resuming_after_os_restart" = true;
    "browser.warnOnQuit" = false;

    "extensions.autoDisableScopes" = 0; # Always enable all installed plugins
    "extensions.autoUpdateDefault" = false;
    "extensions.update.enabled" = false;

    # https://kb.mozillazine.org/Browser.startup.page
    "browser.startup.page" = 3; # means to restore previous session
  };

  extensions = {
    force = true;
    packages = with pkgs.nur.repos.rycee.firefox-addons; [
      firefox-color
      onepassword-password-manager
      consent-o-matic
      tridactyl
      ublock-origin
      sponsorblock
      kagi-search
      raindropio
    ];
  };
  pkg = pkgs.firefox.override {
    nativeMessagingHosts = [ pkgs.tridactyl-native ];
  };
  exe = "${pkg}/Applications/Firefox.app/Contents/MacOS/firefox";
in
mkMod {
  home.shellAliases = lib.optionalAttrs pkgs.stdenv.isDarwin {
    firefox = "${exe} -P 'default' -no-remote";
    firefox-work = "${exe} -P 'work' -no-remote";
  };

  programs.firefox = {
    enable = true;

    package = pkg;

    nativeMessagingHosts = with pkgs; [
      tridactyl-native
    ];

    policies = {
      AppAutoUpdate = false;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      BlockAboutAddons = false;
      BlockAboutConfig = false;
      BlockAboutProfiles = false;
      BlockAobutSupport = false;
      DefaultDownloadDirectory = lib.concatStringsSep "/" [
        config.home.homeDirectory
        "Downloads"
      ];
      DisableFirefoxAccounts = true;
      DisablePocket = true;
      DisableProfileImport = true;
      DisableTelemetry = true;
      DisplayBookmarksToolbar = true;
      DontCheckDefaultBrowser = true;
      EnableTrackingProtection = true;
      ExtensionSettings = {
        "*".installation_mode = "force_installed";
      };
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      ShowHomeButton = true;
      SkipTermsOfUse = true;
      StartDownloadsInTempDirectory = true;
      SupportMenu = true;
      TranslateEnabled = true;
    };

    profiles = {
      default = {
        inherit settings extensions;

        isDefault = true;
        id = 0;
        bookmarks = {
          force = true;
          settings = (import ./bookmarks/shared.nix { }) ++ (import ./bookmarks/personal.nix { });
        };
      };

      work = {
        inherit settings extensions;
        id = 1;
        bookmarks = {
          force = true;
          settings = (import ./bookmarks/shared.nix { }) ++ (import ./bookmarks/work.nix { });
        };
      };
    };
  };
}
