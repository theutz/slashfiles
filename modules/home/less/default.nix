{
  lib,
  config,
  ...
}:
lib.slashfiles.mkModule {
  inherit config;
  here = ./.;
} {
  config = {
    programs = {
      less = {
        enable = true;
        keys = ''
          zl	right-scroll
          zh	left-scroll
        '';
      };
      lesspipe.enable = true;
    };
  };
}
