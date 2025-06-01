-- ~/.config/wezterm/wezterm.local.lua
-- Machine-specific WezTerm configuration
-- Copy this file to ~/.config/wezterm/wezterm.local.lua and customize as needed

local wezterm = require('wezterm')
local config = {}

-- Example: Override default font settings
-- config.font = wezterm.font_with_fallback({
--     { family = "Your Preferred Font", weight = "Regular" },
--     "Your Fallback Font",
-- })
-- config.font_size = 14.0

-- Example: Machine-specific window settings
-- config.window_background_opacity = 1.0
-- config.window_decorations = "RESIZE"
-- config.initial_rows = 40
-- config.initial_cols = 120

-- Example: Custom color overrides
-- config.colors = {
--     foreground = '#custom_fg',
--     background = '#custom_bg',
--     cursor_bg = '#custom_cursor',
--     cursor_fg = '#custom_cursor_text',
-- }

-- Example: Machine-specific launch menu items
-- config.launch_menu = config.launch_menu or {}
-- table.insert(config.launch_menu, {
--     label = "Local Project",
--     args = { "zsh", "-c", "cd ~/projects/local && zsh" },
-- })

-- Example: Custom key bindings
-- table.insert(config.keys, {
--     key = 'e',
--     mods = 'CTRL|SHIFT',
--     action = wezterm.action.SpawnCommandInNewWindow {
--         args = { 'nvim', '.' },
--     },
-- })

-- Example: Local environment variables
-- config.set_environment_variables = config.set_environment_variables or {}
-- config.set_environment_variables['LOCAL_VAR'] = 'value'

-- Example: Machine-specific domains
-- config.unix_domains = {
--     {
--         name = 'unix',
--         serve_command = {'zsh', '-l'},
--     },
-- }

-- Example: Custom workspace setup
-- wezterm.on('gui-startup', function(cmd)
--     local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
--     window:spawn_tab{}
-- end)

return config