{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib.${namespace}.mkMod' config ./.) mkMod;
  inherit (lib.${namespace}) theme font;

  color_scheme =
    ({
      rose-pine = "rose-pine";
      rose-pine-dawn = "rose-pine-dawn";
      rose-pine-moon = "rose-pine-moon";
    }).${theme.name};

  inherit (lib.generators) mkLuaInline toLua;

  mkBind =
    with lib;
    mods: key: action: arg:
    assert isList mods;
    assert isString key;
    assert isString action;
    {
      inherit key;
      action = mkLuaInline "wezterm.action.${action}(${toLua { } arg})";
    }
    // (optionalAttrs (length mods > 0) {
      mods = concatStringsSep "|" mods |> toUpper;
    });

  settings = {
    inherit color_scheme;

    font = mkLuaInline "wezterm.font([[${font.family}]])";
    font_size = font.size;
    line_height = 1.2;
    send_composed_key_when_left_alt_is_pressed = false;
    send_composed_key_when_right_alt_is_pressed = true;
    window_decorations = if pkgs.stdenv.isDarwin then "RESIZE" else "NONE";
    hide_tab_bar_if_only_one_tab = true;
    quick_select_patterns = [
      "^sha256-[0-9A-Za-z+]{40,50}=$"
    ];
    default_prog = [ (lib.getExe pkgs.fish) ];
    debug_key_events = false; # change to log keys while launched from terminal
    leader = {
      key = "m";
      mods = "ALT";
      timeout_milliseconds = 1000;
    };
    keys = [
      (mkBind [ "leader" ] "h" "ActivatePaneDirection" "Left")
      (mkBind [ "leader" ] "j" "ActivatePaneDirection" "Down")
      (mkBind [ "leader" ] "k" "ActivatePaneDirection" "Up")
      (mkBind [ "leader" ] "l" "ActivatePaneDirection" "Right")
      (mkBind [ "leader" ] "n" "ActivateTabRelative" 1)
      (mkBind [ "leader" ] "p" "ActivateTabRelative" (-1))
      (mkBind [ "leader" ] "c" "SpawnTab" "CurrentPaneDomain")
      (mkBind [ "leader" ] "x" "CloseCurrentPane" { confirm = true; })
      (mkBind [ "leader" "shift" ] "X" "CloseCurrentTab" { confirm = true; })
      (mkBind [ "leader" ] "v" "SplitPane" {
        direction = "Right";
        size = {
          Percent = 50;
        };
      })
      (mkBind [ "leader" "shift" ] "|" "SplitPane" {
        direction = "Right";
        size = {
          Percent = 50;
        };
      })
      (mkBind [ "leader" ] "\\" "SplitPane" {
        direction = "Right";
        size = {
          Percent = 50;
        };
        top_level = true;
      })
      (mkBind [ "leader" ] "-" "SplitPane" {
        direction = "Down";
        size = {
          Percent = 50;
        };
      })
      (mkBind [ "leader" "shift" ] "_" "SplitPane" {
        direction = "Down";
        size = {
          Percent = 50;
        };
        top_level = true;
      })
      (mkBind [ "leader" "shift" ] "h" "AdjustPaneSize" [
        "Left"
        5
      ])
      (mkBind [ "leader" "shift" ] "j" "AdjustPaneSize" [
        "Down"
        5
      ])
      (mkBind [ "leader" "shift" ] "k" "AdjustPaneSize" [
        "Up"
        5
      ])
      (mkBind [ "leader" "shift" ] "l" "AdjustPaneSize" [
        "Right"
        5
      ])
    ];
  };
in
mkMod {
  home.packages = [
    (lib.getAttrFromPath font.pkg pkgs)
  ];

  programs.wezterm = {
    enable = true;

    extraConfig =
      # lua
      ''return ${toLua { } settings}'';
  };
}
