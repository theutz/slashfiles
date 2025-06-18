local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Color Scheme

function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return '@dark-theme@';
  else
    return '@light-theme@';
  end
end

config.color_scheme = scheme_for_appearance(get_appearance())
config.window_background_opacity = @opacity@

-- Fonts

config.font = wezterm.font("@font-family@")
config.font_size = @font-size@
config.line_height = @line-height@

-- Shell

config.default_prog = { "@fish@" }

-- GUI/Tabs

config.hide_tab_bar_if_only_one_tab = true
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"

-- Keyboard

config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true

-- For compatibility with mprocs https://github.com/pvolok/mprocs/issues/165
-- config.enable_csi_u_key_encoding = true
return config
