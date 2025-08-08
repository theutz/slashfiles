{ lib, config, ... }:
let
  gap = 32;
  bindPerWorkspace =
    with lib;
    key: action:
    let
      format = template: replacement: replaceString "%d" (toString replacement) template;
      formatWorkspace = num: nameValuePair (format key num) (format action num);
    in
    range 1 9 |> map (formatWorkspace) |> listToAttrs;

  bindPerDirection =
    with lib;
    key: action:
    let
      dirs = {
        h = "left";
        j = "down";
        k = "up";
        l = "right";
      };
      format = template: replacement: replaceString "%s" replacement template;
      formatDirs = n: v: nameValuePair (format key n) (format action v);
    in
    mapAttrs' (formatDirs) dirs |> listToAttrs;
in
{
  after-startup-command = [ ];

  start-at-login = true;

  enable-normalization-flatten-containers = true;
  enable-normalization-opposite-orientation-for-nested-containers = true;

  accordion-padding = gap;

  default-root-container-layout =
    [
      "tiles"
      "accordion"
    ]
    |> lib.flip lib.elemAt 1;

  default-root-container-orientation =
    [
      "horizontal"
      "vertical"
      "auto"
    ]
    |> lib.flip lib.elemAt 2;

  on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

  automatically-unhide-macos-hidden-apps = true;

  key-mapping.preset =
    [
      "qwerty"
      "dvorak"
      "colemak"
    ]
    |> lib.flip lib.elemAt 0;

  gaps =
    let
      gap' = lib.trivial.const gap;
    in
    {
      outer = lib.genAttrs [ "left" "right" "top" "bottom" ] gap';
      inner = lib.genAttrs [ "horizontal" "vertical" ] gap';
    };

  # All possible keys:
  # - Letters.        a, b, c, ..., z
  # - Numbers.        0, 1, 2, ..., 9
  # - Keypad numbers. keypad0, keypad1, keypad2, ..., keypad9
  # - F-keys.         f1, f2, ..., f20
  # - Special keys.   minus, equal, period, comma, slash, backslash, quote, semicolon,
  #                   backtick, leftSquareBracket, rightSquareBracket, space, enter, esc,
  #                   backspace, tab, pageUp, pageDown, home, end, forwardDelete,
  #                   sectionSign (ISO keyboards only, european keyboards only)
  # - Keypad special. keypadClear, keypadDecimalMark, keypadDivide, keypadEnter, keypadEqual,
  #                   keypadMinus, keypadMultiply, keypadPlus
  # - Arrows.         left, down, up, right

  # All possible modifiers: cmd, alt, ctrl, shift

  # All possible commands: https://nikitabobko.github.io/AeroSpace/commands

  # See: https://nikitabobko.github.io/AeroSpace/commands#exec-and-forget
  # You can uncomment the following lines to open up terminal with alt + enter shortcut
  # (like in i3)
  # alt-enter = '''exec-and-forget osascript -e '
  # tell application "Terminal"
  #     do script
  #     activate
  # end tell'
  # '''

  mode.main.binding = lib.mapAttrs' (name: value: lib.nameValuePair ("cmd-alt-ctrl-${name}") value) (
    {
      slash = "layout tiles horizontal vertical";
      comma = "layout accordion horizontal vertical";
      b = "exec-and-forget ${config.home.shellAliases.ff}";
      shift-b = "exec-and-forget ${config.home.shellAliases.ffw}";
      h = "focus --boundaries all-monitors-outer-frame left";
      j = "focus --boundaries all-monitors-outer-frame down";
      k = "focus --boundaries all-monitors-outer-frame up";
      l = "focus --boundaries all-monitors-outer-frame right";
      shift-h = "move --boundaries all-monitors-outer-frame left";
      shift-j = "move --boundaries all-monitors-outer-frame down";
      shift-k = "move --boundaries all-monitors-outer-frame up";
      shift-l = "move --boundaries all-monitors-outer-frame right";
      n = "workspace --wrap-around next";
      shift-n = "move-node-to-workspace next";
      p = "workspace --wrap-around prev";
      shift-p = "move-node-to-workspace prev";
      minus = "resize smart -50";
      equal = "resize smart +50";
      f13 = "mode power";
      m =
        ''
          exec-and-forget ${lib.getExe config.programs.wezterm.package} start --always-new-process
        ''
        |> lib.trim;
    }
    // (bindPerWorkspace "%d" "workspace %d")
    // (bindPerWorkspace "shift-%d" "move-node-to-workspace %d")
  );

  mode.power.binding = {
    esc = "mode main";
    f13 = "mode main";
  }
  // (bindPerWorkspace "%d" "workspace %d");
}
