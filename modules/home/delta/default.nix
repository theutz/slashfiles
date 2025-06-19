{
  lib,
  config,
  namespace,
  ...
}:
lib.slashfiles.mkModule {
  inherit config;
  here = ./.;
} {
  config = {
    programs.git.delta.enable = config.${namespace}.git.enable;

    programs.lazygit.settings.git.paging.pager =
      # bash
      ''
        delta "$(dark-mode status | grep on && echo "--dark" || echo "--light")" --paging=never
      '';
  };
}
