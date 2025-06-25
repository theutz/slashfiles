{lib, ...}: {
  user = "michael";

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
    family = families.hasklug;
    size = 16;
    height = 1.2;
    abs_height = size * height;

    families = let
      mkPropo = name: "${name} Nerd Font Propo";
      mkVariants = family: variants: lib.genAttrs variants (variant: mkPropo (family + variant));
    in {
      blex = mkPropo "BlexMono";
      fira = mkPropo "FiraCode";
      hack = mkPropo "Hack";
      hasklug = mkPropo "Hasklug";
      lilex = mkPropo "Lilex";
      monaspice = mkVariants "Monaspice" ["Ar" "Kr" "Ne" "Rn" "Xe"];
      recursive = mkVariants "RecMono" ["Linear" "Casual" "SmCasual" "Duotone"];
      roboto = mkPropo "RobotoMono";
      sauce = mkPropo "SauceCodePro";
      maple = "Maple Mono NF";
    };

    packages = [
      "nerd-fonts.blex-mono"
      "nerd-fonts.fira-code"
      "nerd-fonts.hack"
      "nerd-fonts.hasklug"
      "nerd-fonts.lilex"
      "nerd-fonts.monaspace"
      "nerd-fonts.recursive-mono"
      "nerd-fonts.roboto-mono"
      "nerd-fonts.sauce-code-pro"
      "maple-mono.NF"
    ];
  };
}
