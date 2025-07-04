{
  lib,
  config,
  ...
}:
lib.slashfiles.mkModule {
  inherit config;
  here = ./.;
} {
  config = let
    posix =
      # bash
      ''
        export OPENAI_API_KEY="$(cat /run/secrets/openai)"
        export ANTHROPIC_API_KEY="$(cat /run/secrets/anthropic)"
        export GEMINI_API_KEY="$(cat /run/secrets/gemini)"
      '';
  in {
    programs.fish.shellInit =
      # fish
      ''
        set -gx OPENAI_API_KEY "$(cat /run/secrets/openai)"
        set -gx ANTHROPIC_API_KEY "$(cat /run/secrets/anthropic)"
        set -gx GEMINI_API_KEY "$(cat /run/secrets/gemini)"
      '';

    programs.bash.initExtra = posix;
    programs.zsh.initContent = posix;
  };
}
