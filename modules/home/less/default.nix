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
          zl	forw 10
          zh	back 10
        '';
      };
      lesspipe.enable = true;
    };
  };
}
