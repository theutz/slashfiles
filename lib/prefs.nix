{lib, ...}: {
  font = rec {
    family = lib.head [
      "RecMonoLinear Nerd Font Propo"
      "RecMonoCasual Nerd Font Propo"
      "RecMonoSmCasual Nerd Font Propo"
      "RecMonoDuotone Nerd Font Propo"
      "RobotoMono Nerd Font Propo"
    ];
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
  };
}
