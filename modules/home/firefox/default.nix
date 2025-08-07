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

  exe =
    # FIXME: Gotta get this working
    lib.asserts.checkAssertWarn
      [
        {
          assertion = pkgs.stdenv.isDarwin;
          message = "Implement this for your platform!";
        }
      ]
      [ "Firefox executable not defined yet for linux." ]
      "${config.programs.firefox.package}/Applications/Firefox.app/Contents/MacOS/firefox";
in
mkMod {
  home.shellAliases = {
    ff = "${exe} -P 'default' -no-remote";
    ffw = "${exe} -P 'work' -no-remote";
  };

  programs.firefox = {
    enable = true;

    package = pkgs.firefox.override {
      nativeMessagingHosts = [ pkgs.tridactyl-native ];
    };

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
        isDefault = true;
        id = 0;

        settings = (import ./settings/shared.nix { });

        extensions = {
          force = true;
          packages = import ./extensions/shared.nix pkgs.nur.repos.rycee.firefox-addons;
        };

        bookmarks = {
          force = true;
          settings = (import ./bookmarks/shared.nix { }) ++ (import ./bookmarks/personal.nix { });
        };
      };

      work = {
        id = 1;

        settings = (import ./settings/shared.nix { });

        extensions = {
          force = true;
          packages = import ./extensions/shared.nix pkgs.nur.repos.rycee.firefox-addons;
        };

        bookmarks = {
          force = true;
          settings = (import ./bookmarks/shared.nix { }) ++ (import ./bookmarks/work.nix { });
        };
      };
    };
  };
}
