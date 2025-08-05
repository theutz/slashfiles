{
  config,
  lib,
  pkgs,
  namespace,
  host,
  ...
}:
let
  inherit (lib.${namespace}.mkMod config ./.) mkConfig;
in
{
  config = mkConfig {
    xdg.desktopEntries.spotify-player = {
      name = "Spotify Player";
      exec = "spotify_player";
      terminal = true;
    };

    home.shellAliases.sp = "spotify_player";

    home.packages = with pkgs; [
      spotify
    ];

    sops.secrets =
      lib.genAttrs
        [
          "spotify_client_id"
          "spotify_password"
        ]
        (_: {
          sopsFile = lib.snowfall.fs.get-file "secrets/api-keys.yaml";
        });

    programs.spotify-player = {
      enable = true;

      settings = {
        theme = "default";
        client_id_command = {
          command = "cat";
          args = [
            config.sops.secrets."spotify_client_id".path
          ];
        };
        client_port = 8080;
        playback_format = ''
          {track} • {artists}
          {album}
          {metadata}'';
        tracks_playback_limit = 50;
        app_refresh_duration_in_ms = 32;
        playback_refresh_duration_in_ms = 0;
        cover_image_refresh_duration_in_ms = 2000;
        page_size_in_rows = 20;
        play_icon = "▶";
        pause_icon = "";
        liked_icon = "";
        border_type = "Rounded";
        progress_bar_type = "Rectangle";
        playback_window_position = "Top";
        cover_img_length = 9;
        cover_img_width = 5;
        cover_img_scale = 1.0;
        playback_window_width = 6;
        enable_media_control = false;
        enable_streaming = "Always";
        enable_cover_image_cache = true;
        default_device = host;
        enable_notify = true;
      };

      keymaps =
        [
          [
            "q"
            "Queue"
          ]
          [
            "C-s"
            "None"
          ]
          [
            "C-r"
            "None"
          ]
          [
            "h"
            "FocusPreviousWindow"
          ]
          [
            "l"
            "FocusNextWindow"
          ]
          [
            "H"
            "PreviousPage"
          ]
        ]
        |> lib.map (
          x:
          x
          |> lib.lists.zipListsWith (a: b: { "${a}" = b; }) [
            "key_sequence"
            "command"
          ]
          |> lib.mergeAttrsList
        );

      actions = [
        {
          action = "ToggleLiked";
          key_sequence = "C-s";
          target = "SelectedItem";
        }
        {
          action = "GoToRadio";
          key_sequence = "C-r";
          target = "SelectedItem";
        }
      ];
    };
  };
}
