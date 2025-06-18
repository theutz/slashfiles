{...}: {
  theme = rec {
    dark = themes.rose-pine.main;
    light = themes.rose-pine.dawn;

    themes = rec {
      kanagawa = {
        main = {
          wezterm = "Kanagawa (Gogh)";
          yazi = "kanagawa";
        };

        dragon = {
          wezterm = "Kanagawa Dragon (Gogh)";
          yazi = "kanagawa-dragon";
        };

        # light theme
        lotus = {
          wezterm = "Kanagawa (Gogh)";
          yazi = "kanagawa-lotus";
        };
      };

      flexoki = {
        light = {
          wezterm = "flexoki-light";
          yazi = "flexoki-light";
        };

        dark = {
          wezterm = "flexoki-dark";
          yazi = "flexoki-dark";
        };
      };

      rose-pine = {
        main = {
          inherit (kanagawa.main) yazi;
          wezterm = "Rosé Pine (Gogh)";
          nvf = "rose-pine";
          tmux = {
            name = "rose-pine";
            defaults = {
              "@rose_pine_variant" = "main";
            };
          };
        };

        dawn = {
          inherit (kanagawa.lotus) yazi;
          wezterm = "Rosé Pine Dawn (Gogh)";
          nvf = "rose-pine";
          tmux = {
            name = "rose-pine";
            defaults = {
              "@rose_pine_variant" = "dawn";
            };
          };
        };

        moon = {
          inherit (kanagawa.main) yazi;
          wezterm = "Rosé Pine Moon (Gogh)";
          nvf = "rose-pine";
          tmux = {
            name = "rose-pine";
            defaults = {
              "@rose_pine_variant" = "moon";
            };
          };
        };
      };
    };
  };

  font = rec {
    family = families.recursive.linear;
    size = 16;
    height = 1.2;
    abs_height = size * height;

    families = {
      recursive = {
        linear = "RecMonoLinear Nerd Font Propo";
        casual = "RecMonoCasual Nerd Font Propo";
        sm-casual = "RecMonoSmCasual Nerd Font Propo";
        duotone = "RecMonoDuotone Nerd Font Propo";
      };
      roboto = "RobotoMono Nerd Font Propo";
    };
  };
}
