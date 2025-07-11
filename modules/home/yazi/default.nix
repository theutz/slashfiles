{
  pkgs,
  lib,
  namespace,
  config,
  ...
}:
lib.${namespace}.mkModule {
  inherit config;
  here = ./.;
} {
  config = {
    home.shellAliases = {
      y = "y";
    };

    programs.yazi = let
      useDuckDb = false;

      themes = {
        kanagawa = "kanagawa";
        kanagawa-dragon = "kanagawa-dragon";
        kanagawa-lotus = "kanagawa-lotus"; # light
        flexoki-light = "flexoki-light";
        flexoki-dark = "flexoki-dark";
        rose-pine = "kanagawa";
        rose-pine-dawn = "kanagawa-lotus"; # light
        rose-pine-moon = "kanagawa";
      };

      inherit (lib.${namespace}.prefs.theme) dark light;
    in {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;

      initLua =
        # lua
        ''
          require("full-border"):setup()
          ${lib.optionalString useDuckDb
            # lua
            ''require("duckdb"):setup()''}
        '';

      plugins = import ./plugins.nix {inherit pkgs;};
      flavors = import ./flavors.nix {inherit pkgs;};
      theme = {
        flavor = {
          dark = themes.${dark};
          light = themes.${light};
        };
      };

      keymap = {
        manager = {
          prepend_keymap =
            # Each item defines the `on`, `run`, and `desc` attrs
            [
              ["q" "close" "Close the current tab, or quit yazi"]
              ["!" ''shell "/opt/homebrew/bin/fish" --block --confirm'' "Open shell here"]
              [["g" "l"] ''shell "lazygit" --block --confirm'' "Open lazygit here"]
              [["g" "r"] ''shell 'ya pub dds-cd --str "$(git rev-parse --show-toplevel)"' --confirm'' "Jump to repo root"]
              [["l"] "plugin smart-enter" "Enter the child directory, or open the file"]
              ["p" "plugin smart-paste" "Paste into the hovered directory or CWD"]
              [["g" "q"] ''shell -- qlmanage -p "$@"'' "Preview with QuickLook"]
              [["C"] "plugin ouch" "Compress with ouch"]
              [["c" "m"] "plugin chmod" "Chmod on selected files"]
              [["c" "o"] ["plugin copy-file-contents"] "Copy contents of file"]
              [["c" "r"] "plugin path-from-root" "Copies path from git root"]
              ["F" "plugin smart-filter" "Smart filter"]
              [["L"] "plugin bypass" "Recursively enter child directory, skipping children with only a single subdirectory"]
            ]
            |> lib.map (i: let
              at = lib.elemAt i;
              on = at 0;
              run = at 1;
              desc = at 2;
            in {inherit on run desc;});
        };
      };

      settings = {
        mgr = {
          show_hidden = true;
        };

        opener = {
          visual = [
            {
              run = ''''${VISUAL:-neovide} "$@"'';
              orphan = true;
              for = "unix";
            }
          ];

          editor = [
            {
              run = ''''${EDITOR:-nvim} "$@"'';
              orphan = true;
              for = "unix";
            }
          ];
        };

        open = {
          prepend_rules = [
            {
              name = "*.html";
              use = ["edit"];
            }
          ];
        };

        plugin = {
          prepend_previewers =
            [
              # Markdown
              {
                name = "*.md";
                run = ''piper -- CLICOLOR_FORCE=1 ${lib.getExe pkgs.glow} -w=$w -s=dark "$1"'';
              }
            ]
            ++ (lib.optional useDuckDb [
              # Structured data
              {
                name = "*.csv";
                run = "duckdb";
              }
              {
                name = "*.tsv";
                run = "duckdb";
              }
              {
                name = "*.json";
                run = "duckdb";
              }
              {
                name = "*.parquet";
                run = "duckdb";
              }
              {
                name = "*.txt";
                run = "duckdb";
              }
              {
                name = "*.xlsx";
                run = "duckdb";
              }
              {
                name = "*.db";
                run = "duckdb";
              }
              {
                name = "*.duckdb";
                run = "duckdb";
              }
            ])
            ++ [
              # Archives
              {
                mime = "application/*zip";
                run = "ouch";
              }
              {
                mime = "application/x-tar";
                run = "ouch";
              }
              {
                mime = "application/x-bzip2";
                run = "ouch";
              }
              {
                mime = "application/x-7z-compressed";
                run = "ouch";
              }
              {
                mime = "application/x-rar";
                run = "ouch";
              }
              {
                mime = "application/x-xz";
                run = "ouch";
              }
              {
                mime = "application/xz";
                run = "ouch";
              }
            ];

          prepend_preloaders = lib.optional useDuckDb [
            {
              name = "*.csv";
              run = "duckdb";
              multi = false;
            }
            {
              name = "*.tsv";
              run = "duckdb";
              multi = false;
            }
            {
              name = "*.json";
              run = "duckdb";
              multi = false;
            }
            {
              name = "*.parquet";
              run = "duckdb";
              multi = false;
            }
            {
              name = "*.txt";
              run = "duckdb";
              multi = false;
            }
            {
              name = "*.xlsx";
              run = "duckdb";
              multi = false;
            }
          ];
        };
      };
    };
  };
}
