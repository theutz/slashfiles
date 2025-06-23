{lib, ...}: {
  theme = rec {
    main = dark;
    dark = "rose-pine";
    light = "rose-pine-dawn";

    supported = [
      "rose-pine"
      "rose-pine-moon"
      "rose-pine-dawn" # light
    ];
  };

  font = rec {
    family = families.monaspice.rn;
    size = 16;
    height = 1.2;
    abs_height = size * height;

    families = let
      mkVariants = family: variants:
        variants
        |> lib.foldl
        (prev: curr:
          prev
          // {
            ${curr |> lib.toLower} = "${family}${curr} Nerd Font Propo";
          }) {};
    in {
      recursive = mkVariants "RecMono" ["Linear" "Casual" "SmCasual" "Duotone"];
      roboto = "RobotoMono Nerd Font Propo";
      blex = "BlexMono Nerd Font Propo";
      lilex = "Lilex Nerd Font Propo";
      monaspice = mkVariants "Monaspice" ["Ar" "Kr" "Ne" "Rn" "Xe"];
      sauce = "SauceCodePro Nerd Font Propo";
    };

    nerdfonts = [
      "blex-mono"
      "roboto-mono"
      "recursive-mono"
      "lilex"
      "hack"
      "fira-code"
      "sauce-code-pro"
      "hasklug"
      "monaspace"
    ];
  };
}
