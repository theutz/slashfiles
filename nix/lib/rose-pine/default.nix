{...}: let
  main = {
    base = "191724";
    surface = "1f1d2e";
    overlay = "26233a";
    muted = "6e6a86";
    subtle = "908caa";
    text = "e0def4";
    love = "eb6f92";
    gold = "f6c177";
    rose = "ebbcba";
    pine = "31748f";
    foam = "9ccfd8";
    iris = "c4a7e7";
    highlight-low = "21202e";
    highlight-med = "403d52";
    highlight-high = "524f67";
  };

  themes = {
    inherit main;
    dark = main;
    default = main;
  };

  color = theme: name: themes.${theme}.${name};
  hex = theme: name: "#${color theme name}";
in {
  rose-pine = {
    inherit main themes hex color;
  };
}
