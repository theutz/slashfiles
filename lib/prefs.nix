{...}: rec {
  theme = {
    dark = themes.rose-pine.main;
    light = themes.rose-pine.dawn;
  };
  themes = {
    rose-pine = {
      main = {
        wezterm = "Rose Pine (Gogh)";
      };
      dawn = {
        wezterm = "Rose Pine Dawn (Gogh)";
      };
      moon = {
        wezterm = "Rose Pine Moon (Gogh)";
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
