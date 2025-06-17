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
    programs.fish.shellInit =
      # fish
      ''
        set -gx OPENAI_API_KEY "$(cat /run/secrets/openai)"
        set -gx ANTHROPIC_API_KEY "$(cat /run/secrets/anthropic)"
        set -gx GEMINI_API_KEY "$(cat /run/secrets/gemini)"
      '';
  };
}
