{
  lib,
  namespace,
  config,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib.${namespace}.prefs.theme) dark light main;

  theme-plugins = rec {
    rose-pine = pkgs.tmuxPlugins.rose-pine;
    rose-pine-dawn = rose-pine;
    rose-pine-moon = rose-pine;
  };

  variants = {
    rose-pine = {"@rose_pine_variant" = "main";};
    rose-pine-moon = {"@rose_pine_variant" = "moon";};
    rose-pine-dawn = {"@rose_pine_variant" = "dawn";};
  };

  mkVariantOpt = theme:
    variants
    |> lib.getAttr theme
    |> lib.foldlAttrs (_: n: v: "${n} '${v}'") null;

  settings = let
    rose-pine = ''
      set -goq ${(mkVariantOpt main)}
      set -g @rose_pine_host 'on'
      set -g @rose_pine_datetime '%Y-%m-%d'
      set -g @rose_pine_user 'on'
      set -g @rose_pine_directory 'on'
      set -g @rose_pine_status_left_prepend_section '#{tmux_mode_indicator}'
    '';
  in {
    inherit rose-pine;
    rose-pine-dawn = rose-pine;
    rose-pine-moon = rose-pine;
    catppuccin-mocha = ''
      set -g status-left-length 100
      set -g status-right-length 100
      set -g status-left ""
      set -g @catppuccin_flavor 'mocha'
      set -g @catppuccin_window_status_style "slanted"
      set -g status-right "#{E:@catppuccin_status_application}"
      set -ag status-right "#{E:@catppuccin_status_session}"
      set -ag status-right "#{E:@catppuccin_status_uptime}"
    '';
  };
in
  lib.${namespace}.mkModule {
    inherit config;
    here = ./.;
  } {
    imports = [
      ./menus.nix
      ./aliases.nix
      ./smart-splits.nix
    ];

    config = {
      launchd.agents.tmux-dark = import ./agent.nix {
        inherit lib pkgs osConfig light dark mkVariantOpt namespace;
      };

      xdg.configFile."tmux/tmux.conf".text = lib.mkBefore settings.${main};

      home.activation.reloadTmux =
        config.lib.dag.entryAfter ["writeBoundary"]
        (pkgs.replaceVars ./activation.bash {
            tmux = lib.getExe pkgs.tmux;
            file = lib.concatStringsSep "/" [config.xdg.configHome "tmux" "tmux.conf"];
          }
          |> lib.fileContents);

      programs.tmux = {
        package = pkgs.tmux;
        plugins = with pkgs.tmuxPlugins; [
          sessionist
          pain-control
          mode-indicator
          theme-plugins.${main}
        ];

        aggressiveResize = true;
        baseIndex = 1;
        clock24 = true;
        enable = true;
        escapeTime = 0;
        extraConfig =
          {
            fish = lib.getExe pkgs.fish;
          }
          |> pkgs.replaceVars ./tmux.conf
          |> lib.fileContents;
        focusEvents = true;
        historyLimit = 10000;
        keyMode = "vi";
        mouse = true;
        newSession = false;
        prefix = "M-m";
        tmuxp.enable = true;
      };
    };
  }
