{...}: {
  font = rec {
    pkg = ["nerd-fonts" "atkynson-mono"];
    family = "AtkynsonMono Nerd Font Propo";
    size = 14;
    px = "${toString size}px";
    float = "${toString size}.0";
  };
}
