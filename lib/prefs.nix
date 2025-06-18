{lib, ...}: {
  theme = rec {
    main = dark;
    dark = "rose-pine-moon";
    light = "rose-pine-dawn";

    supported = [
      "rose-pine"
      "rose-pine-moon"
      "rose-pine-dawn" # light
    ];
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
