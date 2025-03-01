local alpha = require 'alpha'
local dashboard = require 'alpha.themes.dashboard'
dashboard.section.header.val = {
    [[  ██╗ ██╗    ███████╗ █████╗ ███╗   ██╗████████╗████████╗██╗ █████╗  ██████╗     ██╗ ██╗  ]],
    [[ ██╔╝██╔╝    ██╔════╝██╔══██╗████╗  ██║╚══██╔══╝╚══██╔══╝██║██╔══██╗██╔════╝     ╚██╗╚██╗ ]],
    [[██╔╝██╔╝     ███████╗███████║██╔██╗ ██║   ██║      ██║   ██║███████║██║  ███╗     ╚██╗╚██╗]],
    [[╚██╗╚██╗     ╚════██║██╔══██║██║╚██╗██║   ██║      ██║   ██║██╔══██║██║   ██║     ██╔╝██╔╝]],
    [[ ╚██╗╚██╗    ███████║██║  ██║██║ ╚████║   ██║      ██║   ██║██║  ██║╚██████╔╝    ██╔╝██╔╝ ]],
    [[  ╚═╝ ╚═╝    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝      ╚═╝   ╚═╝╚═╝  ╚═╝ ╚═════╝     ╚═╝ ╚═╝  ]],

}
dashboard.section.buttons.val = {
    dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("SPC f f", "󰈞  Find File", ":Telescope fd<CR>"),
    dashboard.button("SPC f r", "󰈢  Recently Opened Files", ":Telescope oldfiles<CR>"),
    dashboard.button("SPC f g", "󰷊  Find Word", ":Telescope live_grep<CR>"),
    dashboard.button("SPC f h", "󰡯  Help Tags", ":Telescope help_tags<CR>"),
    dashboard.button("q", "󰅚  Quit", ":qa<CR>"),
}
-- local handle = io.popen('fortune')
-- local fortune = handle:read("*a")
-- handle:close()
-- dashboard.section.footer.val = fortune

dashboard.config.opts.noautocmd = true
-- Print a message
-- vim.cmd [[autocmd User AlphaReady echo 'ready']]

alpha.setup(dashboard.config)
