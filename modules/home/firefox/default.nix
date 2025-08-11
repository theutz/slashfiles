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

  getExe =
    if pkgs.stdenv.isDarwin then
      "${config.programs.firefox.package}/Applications/Firefox.app/Contents/MacOS/firefox"
    else
      lib.getExe config.programs.firefox.package;
in
mkMod {
  lib.getFirefoxExe = getExe;

  home.shellAliases = {
    ff = "${getExe} -P 'default' -no-remote";
    ffw = "${getExe} -P 'work' -no-remote";
  };

  xdg.dataFile."raycast/scripts/firefox.sh" = {
    source =
      pkgs.writeShellScript "firefox.sh" # bash
        ''
          # @raycast.schemaVersion 1
          # @raycast.title Default Firefox Profile
          # @raycast.mode silent
          # @raycast.packageName Firefox Profiles
          # @raycast.icon 🦊
          ${getExe} -P 'default' -no-remote &
        '';
  };

  xdg.dataFile."raycast/scripts/firefox-work.sh" = {
    source =
      pkgs.writeShellScript "firefox-work.sh"
        # bash
        ''
          # @raycast.schemaVersion 1
          # @raycast.title Work Firefox Profile
          # @raycast.mode silent
          # @raycast.packageName Firefox Profiles
          # @raycast.icon 👨🏻‍💼
          ${getExe} -P 'work' -no-remote &
        '';
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
