local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font("@font-family@")
config.font_size = @font-size@
config.line_height = 1.1
config.color_scheme = "rose-pine"
config.default_prog = { "@fish@" }
config.hide_tab_bar_if_only_one_tab = true
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.85

-- For compatibility with mprocs https://github.com/pvolok/mprocs/issues/165
-- config.enable_csi_u_key_encoding = true
return config
