-- ~/.config/wezterm/wezterm.lua
-- Cross-platform WezTerm configuration optimized for C++/Lua development

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Detect platform for platform-specific settings
local function is_windows()
    return wezterm.target_triple:find("windows") ~= nil
end

local function is_macos()
    return wezterm.target_triple:find("darwin") ~= nil
end

-- Font configuration (works across all platforms with Nerd Fonts)
config.font = wezterm.font_with_fallback({
    { family = "JetBrains Mono", weight = "Regular" },
    "Symbols Nerd Font Mono",
    "Noto Color Emoji",
})
config.font_size = is_macos() and 13.0 or 11.0

-- Custom color scheme matching your preferences
-- Pale/muted bright blue/denim + pale yellow + cherry red accents
config.colors = {
    foreground = '#e6e6e6',
    background = '#000000',

    cursor_bg = '#87ceeb', -- Pale bright blue
    cursor_border = '#87ceeb',
    cursor_fg = '#1a1a1a',

    selection_bg = '#4682b4', -- Denim blue
    selection_fg = '#ffffff',

    ansi = {
        '#2e2e2e', -- black
        '#dc143c', -- cherry red
        '#90ee90', -- green
        '#f0e68c', -- pale yellow
        '#87ceeb', -- pale bright blue
        '#da70d6', -- magenta
        '#4682b4', -- denim blue (cyan)
        '#d3d3d3', -- white
    },
    brights = {
        '#5a5a5a', -- bright black
        '#ff1744', -- bright cherry red
        '#90ee90', -- bright green
        '#fff59d', -- bright pale yellow
        '#87ceeb', -- bright pale blue
        '#da70d6', -- bright magenta
        '#6495ed', -- bright denim blue
        '#ffffff', -- bright white
    },

    tab_bar = {
        background = '#1a1a1a',
        active_tab = {
            bg_color = '#4682b4', -- Denim blue for active tab
            fg_color = '#ffffff',
        },
        inactive_tab = {
            bg_color = '#2e2e2e',
            fg_color = '#87ceeb', -- Pale blue text
        },
        inactive_tab_hover = {
            bg_color = '#3e3e3e',
            fg_color = '#f0e68c', -- Pale yellow on hover
        },
    }
}

-- Window configuration
config.window_background_opacity = 0.95
config.window_decorations = "RESIZE"
config.window_close_confirmation = 'NeverPrompt'


-- Tab configuration
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true

-- Tmux integration settings
config.enable_kitty_keyboard = true -- Better tmux compatibility
config.enable_kitty_graphics = true -- For image support in tmux

-- Key bindings optimized for development workflow
config.keys = {
    -- Tmux-friendly bindings (avoid conflicts)
    { key = 't', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
    { key = 'w', mods = 'CTRL|SHIFT', action = wezterm.action.CloseCurrentTab { confirm = false } },

    -- Pane management (for when not using tmux)
    { key = 'd', mods = 'CTRL|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 'D', mods = 'CTRL|SHIFT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },

    -- Quick config reload
    { key = 'r', mods = 'CTRL|SHIFT', action = wezterm.action.ReloadConfiguration },

    -- Platform-specific shortcuts
    {
        key = 'Enter',
        mods = is_macos() and 'CMD' or 'ALT',
        action = wezterm.action.ToggleFullScreen
    },
}

-- Platform-specific shell configuration
if is_windows() then
    -- MSYS2 UCRT64 configuration using msys2_shell.cmd
    config.default_prog = { 'C:\\msys64\\msys2_shell.cmd', '-ucrt64', '-defterm', '-here', '-no-start', '-shell', 'zsh' }
    config.default_cwd = 'C:\\msys64\\home\\' .. os.getenv('USERNAME')

    -- Multiple shell profiles for MSYS2
    config.launch_menu = {
        {
            label = 'UCRT64 Shell (Zsh)',
            args = { 'C:\\msys64\\msys2_shell.cmd', '-ucrt64', '-defterm', '-here', '-no-start', '-shell', 'zsh' },
        },
        {
            label = 'UCRT64 Shell (Bash)',
            args = { 'C:\\msys64\\msys2_shell.cmd', '-ucrt64', '-defterm', '-here', '-no-start', '-shell', 'bash' },
        },
        {
            label = 'CLANG64 Shell (Zsh)',
            args = { 'C:\\msys64\\msys2_shell.cmd', '-clang64', '-defterm', '-here', '-no-start', '-shell', 'zsh' },
        },
        {
            label = 'MSYS2 Shell (Zsh)',
            args = { 'C:\\msys64\\msys2_shell.cmd', '-msys', '-defterm', '-here', '-no-start', '-shell', 'zsh' },
        },
    }

    -- Key binding to open launch menu
    table.insert(config.keys, {
        key = 'l',
        mods = 'CTRL|SHIFT|ALT',
        action = wezterm.action.ShowLauncher,
    })
elseif is_macos() then
    -- macOS configuration
    config.default_prog = { '/bin/zsh', '--login' }
    config.default_cwd = os.getenv('HOME')
else
    -- Linux configuration
    if os.execute('command -v zsh >/dev/null 2>&1') == 0 then
        config.default_prog = { '/bin/zsh', '--login' }
    else
        config.default_prog = { '/bin/bash', '--login' }
    end
    config.default_cwd = os.getenv('HOME')
end

-- Add shell selection to launch menu for non-Windows platforms
if not is_windows() then
    config.launch_menu = config.launch_menu or {}
    table.insert(config.launch_menu, {
        label = 'Zsh',
        args = { '/bin/zsh', '--login' },
    })
    table.insert(config.launch_menu, {
        label = 'Bash',
        args = { '/bin/bash', '--login' },
    })
end


-- Development-focused tab titles
config.tab_max_width = 32
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    local title = tab.tab_title
    -- If no explicit title, use the current directory name
    if title and #title > 0 then
        return title
    end

    local pane = tab.active_pane
    local dir = pane.current_working_dir
    if dir then
        dir = dir:gsub('file://[^/]*/', '')      -- Remove file:// prefix
        local basename = dir:match('([^/]+)/?$') -- Get directory name
        return basename or 'shell'
    end

    return 'shell'
end)



-- Performance optimizations for development
config.max_fps = 120
config.animation_fps = 60
config.cursor_blink_rate = 800

-- Development-friendly scrollback
config.scrollback_lines = 10000

-- Mouse configuration
config.mouse_bindings = {
    -- Right click paste (useful for terminal workflows)
    {
        event = { Down = { streak = 1, button = 'Right' } },
        mods = 'NONE',
        action = wezterm.action.PasteFrom 'Clipboard',
    },
}

-- Environment variables for cross-platform development
config.set_environment_variables = {
    -- Ensure UTF-8 everywhere
    LC_ALL = 'en_US.UTF-8',
    LANG = 'en_US.UTF-8',

    -- Terminal capabilities
    TERM = 'wezterm',
    COLORTERM = 'truecolor',
}

-- GPU acceleration settings
config.front_end = 'WebGpu' -- Best performance on modern systems
config.webgpu_power_preference = 'HighPerformance'

return config
