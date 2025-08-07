{ lib, ... }:
let
  gap = 32;
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

  gaps = {
    outer = lib.genAttrs [ "left" "right" "top" "bottom" ] (_: gap);
    inner = lib.genAttrs [ "horizontal" "vertical" ] (_: gap);
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
      h = "focus --boundaries all-monitors-outer-frame left";
      j = "focus --boundaries all-monitors-outer-frame down";
      k = "focus --boundaries all-monitors-outer-frame up";
      l = "focus --boundaries all-monitors-outer-frame right";
      "shift-h" = "move --boundaries all-monitors-outer-frame left";
      "shift-j" = "move --boundaries all-monitors-outer-frame down";
      "shift-k" = "move --boundaries all-monitors-outer-frame up";
      "shift-l" = "move --boundaries all-monitors-outer-frame right";
      minus = "resize smart -50";
      equal = "resize smart +50";
    }
    // (
      lib.range 1 9
      |> lib.map builtins.toString
      |> lib.map (x: lib.nameValuePair x "workspace ${x}")
      |> lib.listToAttrs
    )
    // (
      lib.range 1 9
      |> lib.map builtins.toString
      |> lib.map (x: lib.nameValuePair "shift-${x}" "move-node-to-workspace ${x}")
      |> lib.listToAttrs
    )
  );
}
