{lib, ...}: let
  mkMenuItem = {
    name,
    key,
    command,
  }: (''
      "${name}" ${key} {
        ${command}
      }
    ''
    |> lib.strings.trim);

  separator = "''";

  items =
    [
      (mkMenuItem {
        name = "server";
        key = "S";
        command = "kill-server";
      })

      separator

      (mkMenuItem {
        name = "session";
        key = "s";
        command = "respawn-pane -k";
      })
      (mkMenuItem {
        name = "other sessions";
        key = "C-s";
        command = "kill-session -a";
      })
      (mkMenuItem {
        name = "sessions with bells";
        key = "b";
        command = "kill-session -C";
      })

      separator

      (mkMenuItem {
        name = "window";
        key = "w";
        command = "kill-window";
      })
      (mkMenuItem {
        name = "other windows";
        key = "C-w";
        command = "kill-window -a";
      })
      (mkMenuItem {
        name = "respawn window";
        key = "W";
        command = "respawn-window -k";
      })

      separator

      (mkMenuItem {
        name = "pane";
        key = "p";
        command = "kill-pane";
      })
      (mkMenuItem {
        name = "other panes";
        key = "C-p";
        command = "kill-pane -a";
      })
      (mkMenuItem {
        name = "respawn-pane";
        key = "P";
        command = "respawn-pane -k";
      })
    ]
    |> lib.strings.intersperse " "
    |> lib.strings.concatStrings;

  mkMenu = {
    items,
    name,
    key,
    x ? "#{popup_pane_left}",
    y ? "#{popup_pane_bottom}",
  }:
    lib.concatStringsSep " " [
      "bind-key"
      ''-N "Open ${name |> lib.strings.toLower} menu"''
      key
      ''display-menu -T "${name |> lib.strings.toSentenceCase}..."''
      ''-x "${x}"''
      ''-y "${y}"''
      items
    ];

  kill = mkMenu {
    name = "destroy";
    key = "x";
    inherit items;
  };

  # kill = ''
  #   bind-key -N "Open kill menu" x \
  #     display-menu -T "Kill..." -x "#{popup_pane_left}" -y "#{popup_pane_bottom}" \
  #       server S {
  #         kill-server
  #       } ''' session s {
  #         kill-session
  #       } other-sessions C-s {
  #         kill-session -a
  #       } 'bells' b {
  #         kill-session -C
  #       } ''' window w {
  #         kill-window
  #       } other-windows C-w {
  #         kill-window -a
  #       } respawn-window W {
  #         respawn-window -k
  #       } ''' pane p {
  #         kill-pane
  #       } other-panes C-p {
  #         kill-pane -a
  #       } respawn-pane P {
  #         respawn-pane -k
  #       }
  # '';

  layout = ''
    bind-key -N "Open layout menu..." v \
      display-menu -T "Layout..." -xC -yC \
      "Even Horizontal" e {
        select-layout even-horizontal
      } "Even Vertical" E {
        select-layout even-vertical
      } "" "Main Horizontal" M {
        select-layout main-horizontal
      } "Main Vertical" m {
        select-layout main-vertical
      } "" "Main Horizontal (Mirrored)" K {
        select-layout main-horizontal-mirrored
      } "Main Vertical (Mirrored)" k {
        select-layout main-vertical-mirrored
      } "" "Tiled" t {
        select-layout tiled
      }
  '';

  create = ''
    bind-key -N "Open create menu" e \
      display-menu -T "Create..." -x "#{popup_pane_left}" -y "#{popup_pane_bottom}" \
        "Pane below" j {
          command-prompt -p "New pane name:,New pane command:" \
            -I '#T,#{default-shell}' {
              split-window -v '%2'
              select-pane -T '%1'
            }
        } "Pane above" k {
          command-prompt -p "New pane name:,New pane command:" \
            -I '#T,#{default-shell}' {
              split-window -v -b '%2'
              select-pane -T '%1'
            }
        } "Pane right" l {
          command-prompt -p "New pane name:,New pane command:" \
            -I '#T,#{default-shell}' {
              split-window -h '%2'
              select-pane -T '%1'
            }
        } "Pane left" h {
          command-prompt -p "New pane name:,New pane command:" \
            -I '#T,#{default-shell}' {
              split-window -h -b '%2'
              select-pane -T '%1'
            }
        } ''' "Pane below all" J {
          command-prompt -p "New pane name:,New pane command:" \
            -I '#T,#{default-shell}' {
              split-window -v -f '%2'
              select-pane -T '%1'
            }
        } "Pane above all" K {
          command-prompt -p "New pane name:,New pane command:" \
            -I '#T,#{default-shell}' {
              split-window -v -f -b '%2'
              select-pane -T '%1'
            }
        } "Pane far right" L {
          command-prompt -p "New pane name:,New pane command:" \
            -I '#T,#{default-shell}' {
              split-window -h -f '%2'
              select-pane -T '%1'
            }
        } "Pane far left" H {
          command-prompt -p "New pane name:,New pane command:" \
            -I '#T,#{default-shell}' {
              split-window -h -f -b '%2'
              select-pane -T '%1'
            }
        } ''' "New window (end)" w {
          command-prompt -p "New window name:,New window command:,New pane name:" \
            -I '#W,#{default-shell},#T' {
              new-window -n '%1' %2
              select-pane -T '%3'
            }
        } "New window (next)" n {
          command-prompt -p "New window name:,New window command:,New pane name:" \
            -I '#W,#{default-shell},#T' {
              new-window -a -n '%1' %2
              select-pane -T '%3'
            }
        } "New window (prev)" p {
          command-prompt -p "New window name:,New window command:,New pane name:" \
            -I '#W,#{default-shell},#T' {
              new-window -b -n '%1' %2
              select-pane -T '%3'
            }
        } ''' "New session" s {
          command-prompt -p "New session name:,New window name:,New pane command:,New pane name:" \
            -I '#S,#W,#{default-shell},#T' {
              new-session -s '%1' -n '%2' '%3'
              select-pane -T '%4'
            }
        }
  '';

  rename = ''
    bind-key -N "Open rename menu" r \
      display-menu -T "Rename..." -x "#{popup_pane_left}" -y "#{popup_pane_bottom}" \
        session s {
          command-prompt -p "session name:" -I '#{session_name}' { rename-session '%%' }
        } window w {
          command-prompt -p "window name:" -I '#{window_name}' { rename-window '%%' }
        } pane p {
          command-prompt -p "pane title:" -I '#{pane_title}' { select-pane -T '%%' }
        }
  '';
in {
  programs.tmux.extraConfig = lib.concatLines [
    kill
    layout
    create
    rename
  ];
}
