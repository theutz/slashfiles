{lib, ...}: let
  families = let
    mkPropo = name: "${name} Nerd Font Propo";
    mkVariants = family: variants: lib.genAttrs variants (variant: mkPropo (family + variant));
  in {
    annotation = "Annotation Mono";
    atkynson = mkPropo "AtkynsonMono";
    blex = mkPropo "BlexMono";
    fira = mkPropo "FiraCode";
    hack = mkPropo "Hack";
    hasklug = mkPropo "Hasklug";
    intone = mkPropo "IntoneMono";
    lilex = mkPropo "Lilex";
    maple = "Maple Mono NF";
    monaspice = mkVariants "Monaspice" ["Ar" "Kr" "Ne" "Rn" "Xe"];
    recursive = mkVariants "RecMono" ["Linear" "Casual" "SmCasual" "Duotone"];
    roboto = mkPropo "RobotoMono";
    sauce = mkPropo "SauceCodePro";
  };

  size = 16;
  height = 1.2;
in rec {
  packages = [
    "annotation-mono"
    "maple-mono.NF"
    "nerd-fonts.atkynson-mono"
    "nerd-fonts.blex-mono"
    "nerd-fonts.fira-code"
    "nerd-fonts.hack"
    "nerd-fonts.hasklug"
    "nerd-fonts.intone-mono"
    "nerd-fonts.lilex"
    "nerd-fonts.monaspace"
    "nerd-fonts.recursive-mono"
    "nerd-fonts.roboto-mono"
    "nerd-fonts.sauce-code-pro"
  ];

  family = families.atkynson;
  inherit size height;
  abs_height = size * height;
}
