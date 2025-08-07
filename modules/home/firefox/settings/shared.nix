{ }:
{
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
}
