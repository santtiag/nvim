local wezterm = require("wezterm")
local config = {}
-- config.default_domain = 'WSL:Ubuntu-22.04'
-- config.font = wezterm.font("JetBrains Mono")
config.font = wezterm.font('JetBrains Mono', { weight = 'Medium', italic = false })
-- config.font = wezterm.font('FiraCode Nerd Font Mono', { weight = 'Medium', italic = false })

config.color_scheme = "tokyonight"
-- config.color_scheme = "GruvboxDark"
-- config.color_scheme = "Catppuccin Mocha"
config.font_size = 15
config.enable_tab_bar = false
config.initial_cols = 100
config.initial_rows = 25

-- config.default_prog = { "C:/Users/Usuario/AppData/Local/Microsoft/WindowsApps/Microsoft.PowerShell_8wekyb3d8bbwe/pwsh.exe", "-l" }
config.default_prog = { "tmux", "-l" }
config.window_decorations = "RESIZE"
-- config.window_background_opacity = 0.98
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}
config.window_frame = {
    border_left_width = "0cell",
    border_right_width = "0cell",
    border_bottom_height = "0cell",
    border_top_height = "0cell",
}

config.use_fancy_tab_bar = false

return config
