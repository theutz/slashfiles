{
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
    in {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      keymap = {
        manager = {
          prepend_keymap = [
            {
              on = "q";
              run = "close";
              desc = "Close the current tab, or quit yazi";
            }

            {
              on = "!";
              run = ''shell "/opt/homebrew/bin/fish" --block --confirm'';
              desc = "Open shell here";
            }

            {
              on = ["g" "l"];
              run = ''shell "lazygit" --block --confirm'';
              desc = "Open lazygit here";
            }

            {
              on = ["g" "r"];
              run = ''shell 'ya pub dds-cd --str "$(git rev-parse --show-toplevel)"' --confirm'';
              desc = "Jump to repo root";
            }

            {
              on = ["l"];
              run = "plugin smart-enter";
              desc = "Enter the child directory, or open the file";
            }

            {
              on = "p";
              run = "plugin smart-paste";
              desc = "Paste into the hovered directory or CWD";
            }

            {
              on = ["g" "q"];
              run = ''shell -- qlmanage -p "$@"'';
              desc = "Preview with QuickLook";
            }

            {
              on = ["C"];
              run = "plugin ouch";
              desc = "Compress with ouch";
            }

            {
              on = ["c" "m"];
              run = "plugin chmod";
              desc = "Chmod on selected files";
            }

            {
              on = ["c" "o"];
              run = ["plugin copy-file-contents"];
              desc = "Copy contents of file";
            }

            {
              on = ["c" "r"];
              run = "plugin path-from-root";
              desc = "Copies path from git root";
            }

            {
              on = "F";
              run = "plugin smart-filter";
              desc = "Smart filter";
            }

            {
              on = ["L"];
              run = "plugin bypass";
              desc = "Recursively enter child directory, skipping children with only a single subdirectory";
            }
          ];
        };
      };
      settings = {
        manager = {
          show_hidden = true;
        };

        opener = {
          visual = [
            {
              run =
                # bash
                ''
                  ''${VISUAL:-neovide} "$@"
                '';
              orphan = true;
              for = "unix";
            }
          ];
          editor = [
            {
              run =
                # bash
                ''
                  ''${EDITOR:-nvim} "$@"
                '';
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
                run = "glow";
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
