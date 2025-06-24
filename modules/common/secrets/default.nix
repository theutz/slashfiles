{
  pkgs,
  lib,
  config,
  namespace,
  ...
}: let
  mod = baseNameOf ./.;
  cfg = config.${namespace}.${mod};

  owner =
    if config.system ? primaryUser
    then config.system.primaryUser
    else lib.${namespace}.prefs.user;
in {
  options.${namespace}.${mod} = {
    enable = lib.mkEnableOption "secrets config";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sops
      age
    ];

    sops = {
      templates =
        (let
          host = "izmir";
          user = "yesil";
        in {
          "ssh/${host}.conf" = {
            inherit owner;
            content = ''
              Host ${config.sops.placeholder."ssh/hosts/${host}/host"}
              Hostname ${config.sops.placeholder."ssh/hosts/${host}/hostname"}
              User ${config.sops.placeholder."ssh/hosts/${host}/user"}
              IdentityFile ${config.sops.secrets."ssh/users/${user}/priv".path}
            '';
          };
        })
        // (let
          host = "istanbul";
          user = "yesil";
        in {
          "ssh/${host}.conf" = {
            inherit owner;
            content = ''
              Host ${config.sops.placeholder."ssh/hosts/${host}/host"}
              Hostname ${config.sops.placeholder."ssh/hosts/${host}/hostname"}
              User ${config.sops.placeholder."ssh/hosts/${host}/user"}
              IdentityFile ${config.sops.secrets."ssh/users/${user}/priv".path}
            '';
          };
        })
        // (let
          host = "mugla";
          user = "pembe";
        in {
          "ssh/${host}.conf" = {
            inherit owner;
            content = ''
              Host ${config.sops.placeholder."ssh/hosts/${host}/host"}
              Hostname ${config.sops.placeholder."ssh/hosts/${host}/hostname"}
              User ${config.sops.placeholder."ssh/hosts/${host}/user"}
              IdentityFile ${config.sops.secrets."ssh/users/${user}/priv".path}
            '';
          };
        })
        // (let
          host = "sakarya";
          user = "mor";
        in {
          "ssh/${host}.conf" = {
            inherit owner;
            content = ''
              Host ${config.sops.placeholder."ssh/hosts/${host}/host"}
              Hostname ${config.sops.placeholder."ssh/hosts/${host}/hostname"}
              User ${config.sops.placeholder."ssh/hosts/${host}/user"}
              IdentityFile ${config.sops.secrets."ssh/users/${user}/priv".path}
            '';
          };
        })
        // (let
          host = "eskisehir";
          user = "yesil";
        in {
          "ssh/${host}.conf" = {
            inherit owner;
            content = ''
              Host ${config.sops.placeholder."ssh/hosts/${host}/host"}
              Hostname ${config.sops.placeholder."ssh/hosts/${host}/hostname"}
              User ${config.sops.placeholder."ssh/hosts/${host}/user"}
              IdentityFile ${config.sops.secrets."ssh/users/${user}/priv".path}
            '';
          };
        })
        // (let
          host = "manisa";
          user = "yesil";
        in {
          "ssh/${host}.conf" = {
            inherit owner;
            content = ''
              Host ${config.sops.placeholder."ssh/hosts/${host}/host"}
              Hostname ${config.sops.placeholder."ssh/hosts/${host}/hostname"}
              User ${config.sops.placeholder."ssh/hosts/${host}/user"}
              IdentityFile ${config.sops.secrets."ssh/users/${user}/priv".path}
            '';
          };
        })
        // (let
          host = "batman";
          user = "yesil";
        in {
          "ssh/${host}.conf" = {
            inherit owner;
            content = ''
              Host ${config.sops.placeholder."ssh/hosts/${host}/host"}
              User ${config.sops.placeholder."ssh/hosts/${host}/user"}
              IdentityFile ${config.sops.secrets."ssh/users/${user}/priv".path}
            '';
          };
        })
        // (let
          host = "sanliurfa";
          user = "gumus";
        in {
          "ssh/${host}.conf" = {
            inherit owner;
            content = ''
              Host ${config.sops.placeholder."ssh/hosts/${host}/host"}
              Hostname ${config.sops.placeholder."ssh/hosts/${host}/hostname"}
              User ${config.sops.placeholder."ssh/hosts/${host}/user"}
              IdentityFile ${config.sops.secrets."ssh/users/${user}/priv".path}
            '';
          };
        })
        // (let
          host = "erzurum";
          user = "gumus";
        in {
          "ssh/${host}.conf" = {
            inherit owner;
            content = ''
              Host ${config.sops.placeholder."ssh/hosts/${host}/host"}
              Hostname ${config.sops.placeholder."ssh/hosts/${host}/hostname"}
              User ${config.sops.placeholder."ssh/hosts/${host}/user"}
              IdentityFile ${config.sops.secrets."ssh/users/${user}/priv".path}
            '';
          };
        })
        // (let
          host = "bursa";
          user = "mor";
        in {
          "ssh/${host}.conf" = {
            inherit owner;
            content = ''
              Host ${config.sops.placeholder."ssh/hosts/${host}/host"}
              Hostname ${config.sops.placeholder."ssh/hosts/${host}/hostname"}
              User ${config.sops.placeholder."ssh/hosts/${host}/user"}
              IdentityFile ${config.sops.secrets."ssh/users/${user}/priv".path}
            '';
          };
        });

      defaultSopsFile = ../../../secrets.yaml;

      secrets =
        # Private to system user
        (lib.genAttrs [
          "spotify_player/client_id"

          "openai"
          "gemini"
          "anthropic"

          "ssh/hosts/izmir/host"
          "ssh/hosts/izmir/user"
          "ssh/hosts/izmir/hostname"

          "ssh/hosts/istanbul/host"
          "ssh/hosts/istanbul/user"
          "ssh/hosts/istanbul/hostname"

          "ssh/hosts/mugla/host"
          "ssh/hosts/mugla/user"
          "ssh/hosts/mugla/hostname"

          "ssh/hosts/sakarya/host"
          "ssh/hosts/sakarya/user"
          "ssh/hosts/sakarya/hostname"

          "ssh/hosts/eskisehir/host"
          "ssh/hosts/eskisehir/user"
          "ssh/hosts/eskisehir/hostname"

          "ssh/hosts/manisa/host"
          "ssh/hosts/manisa/user"
          "ssh/hosts/manisa/hostname"

          "ssh/hosts/batman/host"
          "ssh/hosts/batman/user"

          "ssh/hosts/sanliurfa/host"
          "ssh/hosts/sanliurfa/user"
          "ssh/hosts/sanliurfa/hostname"

          "ssh/hosts/erzurum/host"
          "ssh/hosts/erzurum/user"
          "ssh/hosts/erzurum/hostname"

          "ssh/hosts/bursa/host"
          "ssh/hosts/bursa/user"
          "ssh/hosts/bursa/hostname"
        ] (_: {inherit owner;}))
        // (let
          mode = "0444";
          priv = {inherit owner;};
          pub = {inherit owner mode;};
        in {
          "ssh/users/mor/priv" = priv;
          "ssh/users/mor/pub" = pub;

          "ssh/users/koyu_mor/priv" = priv;
          "ssh/users/koyu_mor/pub" = pub;

          "ssh/users/beyaz/priv" = priv;
          "ssh/users/beyaz/pub" = pub;

          "ssh/users/yesil/priv" = priv;
          "ssh/users/yesil/pub" = pub;

          "ssh/users/pembe/priv" = priv;
          "ssh/users/pembe/pub" = pub;

          "ssh/users/gri/priv" = priv;
          "ssh/users/gri/pub" = pub;

          "ssh/users/sari/priv" = priv;
          "ssh/users/sari/pub" = pub;

          "ssh/users/gumus/priv" = priv;
          "ssh/users/gumus/pub" = pub;
        });
    };
  };
}
