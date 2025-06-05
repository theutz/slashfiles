{
  lib,
  pkgs,
  namespace,
  ...
}: let
  mkMenu = {
    name,
    key,
    mkItems,
    x ? "#{popup_pane_left}",
    y ? "#{popup_pane_bottom}",
  }: let
    divider = "''";
    mkItem = key: name: command: (''
        "${name |> lib.strings.trim |> lib.strings.toSentenceCase}" ${key |> lib.strings.trim} {
          ${command |> lib.strings.trim}
        }
      ''
      |> lib.strings.trim);
  in
    lib.concatStringsSep " " [
      "bind-key"
      ''-N "Open '${name |> lib.strings.toSentenceCase}' menu"''
      key
      ''display-menu -T "${name |> lib.strings.toSentenceCase}..."''
      ''-x "${x}"''
      ''-y "${y}"''
      (mkItems {
          inherit mkItem divider;
        }
        |> lib.strings.intersperse " "
        |> lib.strings.concatStrings)
    ];
  mkPopup = {
    title,
    command,
    autoClose ? "success",
    border ? true,
    closeOthers ? false,
    x ? "C",
    y ? "C",
    w ? "90%",
    h ? "90%",
  }: let
    B =
      if border
      then ""
      else "-B";
    C =
      if closeOthers
      then "-C"
      else "";
    E =
      if autoClose == "success"
      then "-EE"
      else if autoClose == "always"
      then "-E"
      else "";
  in
    [
      "display-popup"
      B
      C
      E
      ''-x "${x}"''
      ''-y "${y}"''
      ''-h "${builtins.toString h}"''
      ''-w "${builtins.toString w}"''
      ''-T "${title |> lib.strings.trim |> lib.strings.toSentenceCase}"''
      (command |> lib.strings.trim)
    ]
    |> lib.strings.concatStringsSep " ";
in {
  programs.tmux.extraConfig = lib.concatLines [
    (mkMenu {
      name = "goto";
      key = "g";
      x = "C";
      y = "C";
      mkItems = {
        mkItem,
        divider,
        ...
      }: [
        (mkItem "g" "lazygit" (mkPopup {
          title = "lazygit";
          command = "lazygit";
        }))
        divider
        (mkItem "s" "spotify" (mkPopup {
          title = "spotify";
          command = "spotify_player";
        }))
        (mkItem "v" "volume" (mkPopup {
          title = "volume";
          command = "volgo";
          h = 7;
          w = 80;
        }))
      ];
    })
    (mkMenu {
      name = "set layout";
      key = "v";
      x = "C";
      y = "C";
      mkItems = {
        divider,
        mkItem,
      }: [
        (mkItem "E" "Even Vertical" ''
          select-layout even-vertical
        '')
        (mkItem "e" "Even Horizontal" ''
          select-layout even-horizontal
        '')

        divider

        (mkItem "m" "Main Vertical" ''
          select-layout main-vertical
        '')
        (mkItem "M" "Main Horizontal" ''
          select-layout main-horizontal
        '')

        divider

        (mkItem "o" "Main Vertical (Mirrored)" ''
          select-layout main-vertical-mirrored
        '')
        (mkItem "O" "Main Horizontal (Mirrored)" ''
          select-layout main-horizontal-mirrored
        '')

        divider

        (mkItem "t" "Tiled" ''
          select-layout tiled
        '')
      ];
    })

    (mkMenu {
      name = "kill";
      key = "x";
      mkItems = {
        divider,
        mkItem,
      }: [
        (mkItem "S" "the whole server" "kill-server")
        divider
        (mkItem "s" "this session" "respawn-pane -k")
        (mkItem "C-s" "other sessions" "kill-session -a")
        (mkItem "b" "any sessions with bells" "kill-session -C")
        divider
        (mkItem "w" "this window" "kill-window")
        (mkItem "C-w" "other windows" "kill-window -a")
        (mkItem "W" "respawn this window" "respawn-window -k")
        divider
        (mkItem "p" "this pane" "kill-pane")
        (mkItem "C-p" "other panes" "kill-pane -a")
        (mkItem "P" "respawn this pane" "respawn-pane -k")
      ];
    })

    (mkMenu {
      name = "rename";
      key = "r";
      mkItems = {
        divider,
        mkItem,
      }: [
        (mkItem "s" "this session" ''
          command-prompt -p "session name:" -I '#{session_name}' { rename-session '%%' }
        '')
        (mkItem "w" "this window" ''
          command-prompt -p "window name:" -I '#{window_name}' { rename-window '%%' }
        '')
        (mkItem "p" "this pane" ''
          command-prompt -p "pane title:" -I '#{pane_title}' { select-pane -T '%%' }
        '')
      ];
    })

    (mkMenu {
      name = "create";
      key = "e";
      mkItems = {
        divider,
        mkItem,
      }: [
        (mkItem "j" "Pane below" ''
          command-prompt -p "New pane name:,New pane command:" \
            -I '#T,#{default-shell}' {
              split-window -v '%2'
              select-pane -T '%1'
            }
        '')
        (mkItem "k" "Pane above" ''
          command-prompt -p "New pane name:,New pane command:" \
            -I '#T,#{default-shell}' {
              split-window -v -b '%2'
              select-pane -T '%1'
            }
        '')
        (mkItem "l" "Pane right" ''
          command-prompt -p "New pane name:,New pane command:" \
            -I '#T,#{default-shell}' {
              split-window -h '%2'
              select-pane -T '%1'
            }
        '')
        (mkItem "h" "Pane left" ''
          command-prompt -p "New pane name:,New pane command:" \
            -I '#T,#{default-shell}' {
              split-window -h -b '%2'
              select-pane -T '%1'
            }
        '')
        divider
        (mkItem "J" "Pane below all" ''
          command-prompt -p "New pane name:,New pane command:" \
            -I '#T,#{default-shell}' {
              split-window -v -f '%2'
              select-pane -T '%1'
            }
        '')
        (mkItem "K" "Pane above all" ''
          command-prompt -p "New pane name:,New pane command:" \
            -I '#T,#{default-shell}' {
              split-window -v -f -b '%2'
              select-pane -T '%1'
            }
        '')
        (mkItem "L" "Pane far right" ''
          command-prompt -p "New pane name:,New pane command:" \
            -I '#T,#{default-shell}' {
              split-window -h -f '%2'
              select-pane -T '%1'
            }
        '')
        (mkItem "H" "Pane far left" ''
          command-prompt -p "New pane name:,New pane command:" \
            -I '#T,#{default-shell}' {
              split-window -h -f -b '%2'
              select-pane -T '%1'
            }
        '')
        divider
        (mkItem "w" "New window (end)" ''
          command-prompt -p "New window name:,New window command:,New pane name:" \
            -I '#W,#{default-shell},#T' {
              new-window -n '%1' %2
              select-pane -T '%3'
            }
        '')
        (mkItem "n" "New window (next)" ''
          command-prompt -p "New window name:,New window command:,New pane name:" \
            -I '#W,#{default-shell},#T' {
              new-window -a -n '%1' %2
              select-pane -T '%3'
            }
        '')
        (mkItem "p" "New window (prev)" ''
          command-prompt -p "New window name:,New window command:,New pane name:" \
            -I '#W,#{default-shell},#T' {
              new-window -b -n '%1' %2
              select-pane -T '%3'
            }
        '')
        divider
        (mkItem "s" "New session" ''
          command-prompt -p "New session name:,New window name:,New pane command:,New pane name:" \
            -I '#S,#W,#{default-shell},#T' {
              new-session -s '%1' -n '%2' '%3'
              select-pane -T '%4'
            }
        '')
      ];
    })
  ];
}
