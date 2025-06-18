{...}: rec {
  theme = {
    dark = themes.rose-pine.main;
    light = themes.rose-pine.dawn;
  };
  themes = {
    rose-pine = {
      main = {
        wezterm = "Rosé Pine (Gogh)";
        yazi = "rose-pine";
      };
      dawn = {
        wezterm = "Rosé Pine Dawn (Gogh)";
        yazi = "rose-pine";
      };
      moon = {
        wezterm = "Rosé Pine Moon (Gogh)";
        yazi = "rose-pine";
      };
    };
  };
  font = rec {
    family = families.recursive.linear;
    families = {
      recursive = {
        linear = "RecMonoLinear Nerd Font Propo";
        casual = "RecMonoCasual Nerd Font Propo";
        sm-casual = "RecMonoSmCasual Nerd Font Propo";
        duotone = "RecMonoDuotone Nerd Font Propo";
      };
      roboto = "RobotoMono Nerd Font Propo";
    };
    size = 16;
    height = 1.2;
    abs_height = size * height;
  };
}
