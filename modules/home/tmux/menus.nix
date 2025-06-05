{lib, ...}: let
  mkMenu = {
    name,
    key,
    mkItems,
    x ? "#{popup_pane_left}",
    y ? "#{popup_pane_bottom}",
  }: let
    divider = "''";
    mkItem = key: name: command: (''
        "${name |> lib.strings.trim}" ${key |> lib.strings.trim} {
          ${command |> lib.strings.trim}
        }
      ''
      |> lib.strings.trim);
  in
    lib.concatStringsSep " " [
      "bind-key"
      ''-N "Open ${name |> lib.strings.toLower} menu"''
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
in {
  programs.tmux.extraConfig = lib.concatLines [
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

    # create = ''
    #   bind-key -N "Open create menu" e \
    #     display-menu -T "Create..." -x "#{popup_pane_left}" -y "#{popup_pane_bottom}" \
    #       "Pane below" j {
    #         command-prompt -p "New pane name:,New pane command:" \
    #           -I '#T,#{default-shell}' {
    #             split-window -v '%2'
    #             select-pane -T '%1'
    #           }
    #       } "Pane above" k {
    #         command-prompt -p "New pane name:,New pane command:" \
    #           -I '#T,#{default-shell}' {
    #             split-window -v -b '%2'
    #             select-pane -T '%1'
    #           }
    #       } "Pane right" l {
    #         command-prompt -p "New pane name:,New pane command:" \
    #           -I '#T,#{default-shell}' {
    #             split-window -h '%2'
    #             select-pane -T '%1'
    #           }
    #       } "Pane left" h {
    #         command-prompt -p "New pane name:,New pane command:" \
    #           -I '#T,#{default-shell}' {
    #             split-window -h -b '%2'
    #             select-pane -T '%1'
    #           }
    #       } ''' "Pane below all" J {
    #         command-prompt -p "New pane name:,New pane command:" \
    #           -I '#T,#{default-shell}' {
    #             split-window -v -f '%2'
    #             select-pane -T '%1'
    #           }
    #       } "Pane above all" K {
    #         command-prompt -p "New pane name:,New pane command:" \
    #           -I '#T,#{default-shell}' {
    #             split-window -v -f -b '%2'
    #             select-pane -T '%1'
    #           }
    #       } "Pane far right" L {
    #         command-prompt -p "New pane name:,New pane command:" \
    #           -I '#T,#{default-shell}' {
    #             split-window -h -f '%2'
    #             select-pane -T '%1'
    #           }
    #       } "Pane far left" H {
    #         command-prompt -p "New pane name:,New pane command:" \
    #           -I '#T,#{default-shell}' {
    #             split-window -h -f -b '%2'
    #             select-pane -T '%1'
    #           }
    #       } ''' "New window (end)" w {
    #         command-prompt -p "New window name:,New window command:,New pane name:" \
    #           -I '#W,#{default-shell},#T' {
    #             new-window -n '%1' %2
    #             select-pane -T '%3'
    #           }
    #       } "New window (next)" n {
    #         command-prompt -p "New window name:,New window command:,New pane name:" \
    #           -I '#W,#{default-shell},#T' {
    #             new-window -a -n '%1' %2
    #             select-pane -T '%3'
    #           }
    #       } "New window (prev)" p {
    #         command-prompt -p "New window name:,New window command:,New pane name:" \
    #           -I '#W,#{default-shell},#T' {
    #             new-window -b -n '%1' %2
    #             select-pane -T '%3'
    #           }
    #       } ''' "New session" s {
    #         command-prompt -p "New session name:,New window name:,New pane command:,New pane name:" \
    #           -I '#S,#W,#{default-shell},#T' {
    #             new-session -s '%1' -n '%2' '%3'
    #             select-pane -T '%4'
    #           }
    #       }
    # '';

    layout
  ];
}
