local wezterm = require("wezterm")

local M = {}

-- Config
M.default_prog = { "nu" }
M.font = wezterm.font_with_fallback { "Hack nerd font" }
M.font_size = 11
M.check_for_updates = false
M.window_close_confirmation = "NeverPrompt"
M.initial_cols = 120
M.initial_rows = 30
M.enable_wayland = false
M.window_background_opacity = 0.8
M.window_decorations = "NONE"
M.enable_tab_bar = true
M.use_fancy_tab_bar = false
M.hide_tab_bar_if_only_one_tab = false
-- M.front_end = "WebGpu"

-- Theme
M.color_scheme_dirs = {'/home/islam/.cache/wal/'}
M.color_scheme = ('colors-wezterm')
wezterm.add_to_config_reload_watch_list('/home/islam/.cache/wal/colors-wezterm.toml')

return M
