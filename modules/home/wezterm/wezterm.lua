local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font("RobotoMono Nerd Font Propo")
config.font_size = 16
config.line_height = 1.1
config.color_scheme = "rose-pine"
config.default_prog = { "${lib.getExe pkgs.fish}" }
config.hide_tab_bar_if_only_one_tab = true
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true

-- For compatibility with mprocs https://github.com/pvolok/mprocs/issues/165
-- config.enable_csi_u_key_encoding = true
return config
