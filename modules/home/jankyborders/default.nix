{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkMod cfg;
  inherit (lib.${namespace}.rose-pine) argb;
  clr = argb "main";
in
mkMod [
  {
    warnings = lib.optionals (!pkgs.stdenv.isDarwin && cfg.enable) [
      ''
        JankyBorders is only available on MacOS.
        This module will be disabled.
      ''
    ];
  }

  (lib.mkIf pkgs.stdenv.isDarwin {
    services.jankyborders = {
      enable = true;
      settings = {
        style = "round";
        width = 16.0;
        hidpi = "off";
        active_color = clr "rose" "ff";
        inactive_color = clr "pine" "88";
        background_color = clr "base" "44";
      };
    };

    home.activation.restartJankyBorders =
      config.lib.dag.entryAfter [ "writeBoundary" ]
        # bash
        ''
          verboseEcho "Restarting JankyBorders"
          run /bin/launchctl kickstart -k gui/''$(id -u ${config.home.username})/org.nix-community.home.jankyborders
        '';
  })
]
