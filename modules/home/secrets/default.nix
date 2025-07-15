{
  lib,
  config,
  namespace,
  osConfig,
  ...
}: let
  mod = builtins.baseNameOf ./.;
  cfg = config.${namespace}.${mod};

  openai = osConfig.sops.secrets.openai.path;
  anthropic = osConfig.sops.secrets.anthropic.path;
  gemini = osConfig.sops.secrets.gemini.path;

  posix =
    # bash
    ''
      export OPENAI_API_KEY="$(cat ${openai})"
      export ANTHROPIC_API_KEY="$(cat ${anthropic})"
      export GEMINI_API_KEY="$(cat ${gemini})"
    '';
in {
  options.${namespace}.${mod}.enable = lib.mkEnableOption "enable ${mod}";

  config = lib.mkIf cfg.enable {
    programs.bash.initExtra = posix;
    programs.zsh.initContent = posix;
    programs.fish.shellInit =
      # fish
      ''
        set -gx OPENAI_API_KEY "$(cat ${openai})"
        set -gx ANTHROPIC_API_KEY "$(cat ${anthropic})"
        set -gx GEMINI_API_KEY "$(cat ${gemini})"
      '';
  };
}
