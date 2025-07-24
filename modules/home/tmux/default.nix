{
  lib,
  namespace,
  config,
  pkgs,
  osConfig,
  ...
}: let
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};
in {
  imports = [
    ./menus.nix
    ./aliases.nix
    ./smart-splits.nix
    ./themes.nix
  ];

  options.${namespace}.${mod} = {
    enable = lib.mkEnableOption "control tmux with an iron fist";

    tmuxConf = lib.mkOption {
      type = config.lib.types.dagOf lib.types.str;
      description = ''
        DAG to describe additional TMUX config. Entries before "hmBoundary"
        will precede any config written by home-manager settings. Any
        plugin-specific settings should probably be set there.
      '';
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    home.file.".tmuxp.yaml" = {
      source = ./.tmuxp.yaml;
      force = true;
    };

    ${namespace}.${mod}.tmuxConf.hmBoundary = lib.mkDefault ''
      # ${namespace}.${mod} boundary
    '';

    xdg.configFile."tmux/tmux.conf".text =
      cfg.tmuxConf
      |> config.lib.dag.topoSort
      |> lib.getAttr "result"
      |> (sorted: let
        defaultIndex = 0;
        boundaryIndex =
          lib.lists.findFirstIndex
          (x: x.name == "hmBoundary")
          defaultIndex
          sorted;
      in
        lib.take boundaryIndex sorted)
      |> lib.concatMapStringsSep "\n" (x: x.data)
      |> lib.mkBefore;

    home.activation.reloadTmux = let
      tmux = lib.getExe pkgs.tmux;
      file = lib.concatStringsSep "/" [config.xdg.configHome "tmux" "tmux.conf"];
    in
      config.lib.dag.entryAfter ["writeBoundary"]
      # bash
      ''
        export TERM="xterm-256color"

        if
          run ${tmux} ls &>/dev/null
        then
          verboseEcho "Reloading tmux..."
          if
            run ${tmux} source-file "${file}"
          then
            verboseEcho "Tmux config reloaded!"
          else
            echo "ERROR: Could not reload tmux config."
          fi
        else
          verboseEcho "No tmux running"
        fi
      '';

    programs.tmux = {
      package = pkgs.tmux;

      plugins = with pkgs.tmuxPlugins; [
        sessionist
        pain-control
        mode-indicator
      ];

      aggressiveResize = true;
      baseIndex = 1;
      clock24 = true;
      enable = true;
      escapeTime = 0;
      extraConfig = let
        conf =
          {
            fish = lib.getExe pkgs.fish;
          }
          |> pkgs.replaceVars ./tmux.conf;
      in ''
        source-file ${conf}
      '';
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
