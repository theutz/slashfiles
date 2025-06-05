{
  lib,
  config,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) mkModule;
in
  mkModule {
    inherit config;
    here = ./.;
  } {
    config = {
      programs.mise = {
        enable = true;
        # programs.mise.enableBashIntegration
        #     Whether to enable Bash integration.
        #
        #     Type: boolean
        #
        #     Default: home.shell.enableBashIntegration[1]
        #
        #     Example: false
        #
        #     Declared by:
        #         <home-manager/modules/programs/mise.nix>
        #
        #      1. see the home.shell.enableBashIntegration option
        #
        # programs.mise.enableFishIntegration
        #     Whether to enable Fish integration.
        #
        #     Type: boolean
        #
        #     Default: home.shell.enableFishIntegration[1]
        #
        #     Example: false
        #
        #     Declared by:
        #         <home-manager/modules/programs/mise.nix>
        #
        #      1. see the home.shell.enableFishIntegration option
        #
        # programs.mise.enableNushellIntegration
        #     Whether to enable Nushell integration.
        #
        #     Type: boolean
        #
        #     Default: home.shell.enableNushellIntegration[1]
        #
        #     Example: false
        #
        #     Declared by:
        #         <home-manager/modules/programs/mise.nix>
        #
        #      1. see the home.shell.enableNushellIntegration option
        #
        # programs.mise.enableZshIntegration
        #     Whether to enable Zsh integration.
        #
        #     Type: boolean
        #
        #     Default: home.shell.enableZshIntegration[1]
        #
        #     Example: false
        #
        #     Declared by:
        #         <home-manager/modules/programs/mise.nix>
        #
        #      1. see the home.shell.enableZshIntegration option
        #
        # programs.mise.package
        #     The mise package to use.
        #
        #     Type: null or package
        #
        #     Default: pkgs.mise
        #
        #     Declared by:
        #         <home-manager/modules/programs/mise.nix>
        #
        # programs.mise.globalConfig
        #     Config written to $XDG_CONFIG_HOME/mise/config.toml.
        #
        #     See https://mise.jdx.dev/configuration.html#global-config-config-mise-config-toml[1] for details on supported values.
        #
        #     Type: TOML value
        #
        #     Default: { }
        #
        #     Example:
        #
        #         tools = {
        #           node = "lts";
        #           python = ["3.10" "3.11"];
        #         };
        #
        #         aliases = {
        #           my_custom_node = "20";
        #         };
        #
        #     Declared by:
        #         <home-manager/modules/programs/mise.nix>
        #
        #      1. https://mise.jdx.dev/configuration.html#global-config-config-mise-config-toml
        #
        # programs.mise.settings
        #     Settings written to $XDG_CONFIG_HOME/mise/settings.toml.
        #
        #     See https://mise.jdx.dev/configuration.html#settings-file-config-mise-settings-toml[1] for details on supported values.
        #
        #     Type: TOML value
        #
        #     Default: { }
        #
        #     Example:
        #
        #         verbose = false;
        #         experimental = false;
        #         disable_tools = ["node"];
        #
        #     Declared by:
        #         <home-manager/modules/programs/mise.nix>
        #
        #      1. https://mise.jdx.dev/configuration.html#settings-file-config-mise-settings-toml
      };
    };
  }
