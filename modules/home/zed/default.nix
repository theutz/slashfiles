{
  lib,
  namespace,
  config,
  ...
}:
lib.${namespace}.mkModule {
  inherit config;
  here = ./.;
} {
  config = {
    programs.zed-editor = {
      enable = true;
      extensions = [
        "rose-pine-theme"
        "html"
        "toml"
        "dockerfile"
        "php"
        "sql"
        "ruby"
        "terraform"
        "lua"
        "graphql"
        "rainbow-csv"
        "ini"
        "blade"
        "just"
        "ansible"
        "nu"
        "nix"
      ];
      userSettings = {
        vim_mode = true;
      };
    };
  };
}
