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
      theme = {
        flavor = {
          dark = lib.${namespace}.prefs.theme.dark.yazi;
          light = lib.${namespace}.prefs.theme.light.yazi;
        };
      };
      plugins = {
        inherit
          (pkgs.yaziPlugins)
          chmod
          duckdb
          full-border
          git
          glow
          lazygit
          miller
          ouch
          projects
          relative-motions
          rsync
          smart-enter
          smart-filter
          smart-paste
          starship
          sudo
          vcs-files
          ;
        path-from-root = pkgs.fetchFromGitHub {
          owner = "aresler";
          repo = "path-from-root";
          rev = "7d05b87";
          hash = "sha256-JSl9S8kxD8XoN21WfJwjEGwDB+/McjrTv+8SbXvZKds=";
        };
        copy-file-contents =
          {
            owner = "AnirudhG07";
            repo = "plugins-yazi";
            rev = "524c52c";
            hash = "sha256-GrPqcHYG+qHNi80U+EJJd1JjdAOexiE6sQxsqdeCSMg=";
          }
          |> pkgs.fetchFromGitHub
          |> (p: "${p.outPath}/copy-file-contents.yazi");
      };
      flavors = {
        rose-pine = pkgs.fetchFromGitHub {
          owner = "jamylak";
          repo = "rose-pine.yazi";
          rev = "main";
          hash = "sha256-y+MVU6y73dLXiTrzkbG6/xc0xKcZyywBCZabVL6nAQg=";
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
        manager = {
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
