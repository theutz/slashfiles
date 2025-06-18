{
  lib,
  namespace,
  config,
  pkgs,
  osConfig,
  ...
}:
lib.${namespace}.mkModule {
  inherit config;
  here = ./.;
} {
  imports = [
    ./menus.nix
    ./aliases.nix
    ./smart-splits.nix
  ];

  config = let
    inherit (pkgs.tmuxPlugins) rose-pine catppuccin;

    dark = lib.${namespace}.prefs.theme.dark.tmux;
    light = lib.${namespace}.prefs.theme.light.tmux;

    plugins =
      (with pkgs.tmuxPlugins; [
        sessionist
        pain-control
        mode-indicator
      ])
      ++ [pkgs.tmuxPlugins.${dark.name}] ++ (lib.optional (dark.name != light.name) [pkgs.tmuxPlugins.${light.name}]);

    hasPlugin = (lib.flip lib.elem) plugins;

    catppuccinSettings = ''
      set -g status-left-length 100
      set -g status-right-length 100
      set -g status-left ""
      set -g @catppuccin_flavor 'mocha'
      set -g @catppuccin_window_status_style "slanted"
      set -g status-right "#{E:@catppuccin_status_application}"
      set -ag status-right "#{E:@catppuccin_status_session}"
      set -ag status-right "#{E:@catppuccin_status_uptime}"
    '';

    rosePineSettings = let
      variant =
        dark.defaults
        |> lib.mapAttrsToList (name: value: "set -goq ${name} '${value}'")
        |> lib.concatLines;
    in ''
      ${variant}
      set -g @rose_pine_host 'on'
      set -g @rose_pine_datetime '%Y-%m-%d'
      set -g @rose_pine_user 'on'
      set -g @rose_pine_directory 'on'
      set -g @rose_pine_status_left_prepend_section '#{tmux_mode_indicator}'
    '';
  in {
    launchd.agents.tmux-dark = import ./agent.nix {inherit lib pkgs osConfig light dark;};

    xdg.configFile."tmux/tmux.conf".text = lib.mkBefore ''
      ${lib.optionalString (hasPlugin catppuccin) catppuccinSettings}
      ${lib.optionalString (hasPlugin rose-pine) rosePineSettings}
    '';

    home.activation.reloadTmux =
      config.lib.dag.entryAfter ["writeBoundary"]
      (pkgs.replaceVars ./activation.bash {
          tmux = lib.getExe pkgs.tmux;
          file = lib.concatStringsSep "/" [config.xdg.configHome "tmux" "tmux.conf"];
        }
        |> lib.fileContents);

    programs.tmux = {
      inherit plugins;

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
      keyMode = "vi";
      mouse = true;
      prefix = "M-m";
      tmuxp.enable = true;
    };
  };
}
