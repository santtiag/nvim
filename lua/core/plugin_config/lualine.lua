local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
        local filepath = vim.fn.expand('%:p:h')
        local gitdir = vim.fn.finddir('.git', filepath .. ';')
        return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
}

local colors = {
    bg       = '#202328',
    fg       = '#bbc2cf',
    yellow   = '#ECBE7B',
    cyan     = '#008080',
    darkblue = '#081633',
    green    = '#98be65',
    orange   = '#FF8800',
    violet   = '#a9a1e1',
    magenta  = '#c678dd',
    blue     = '#51afef',
    red      = '#ec5f67',
}


require('lualine').setup {
    options = {
        icons_enabled = true,
        -- theme = 'catppuccin-mocha',
        -- theme = 'gruvbox',
        theme = 'tokyonight',
        -- theme = 'auto',
        component_separators = { left = '', right = '' },
        -- section_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = { 'oil', 'AvanteInput', 'Avante', 'AvanteSelectedFiles', 'trouble', 'AvanteTodos'},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {
            { 'branch' },
            {
                'diff',
                symbols = { added = ' ', modified = ' ', removed = ' ' },
                diff_color = {
                    added = { fg = colors.green },
                    modified = { fg = colors.orange },
                    removed = { fg = colors.red },
                }
            },
            {
                'diagnostics',
                sources = { 'nvim_diagnostic' },
                symbols = {
                    error = ' ',
                    warn  = ' ',
                    info  = ' '
                },
                diagnostics_color = {
                    error = { fg = colors.red },
                    warn  = { fg = colors.yellow },
                    info  = { fg = colors.cyan },
                },
                cond = conditions.hide_in_width,
                separator = ''
            },
        },

        lualine_c = {
            {
                'filename',
                cond = conditions.buffer_not_empty,
                color = { fg = colors.magenta, gui = 'bold' }


            },
            {
                function()
                    local msg = 'No Active Lsp'
                    local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
                    local clients = vim.lsp.get_clients()
                    if next(clients) == nil then
                        return msg
                    end
                    for _, client in ipairs(clients) do
                        local filetypes = client.config.filetypes
                        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                            return client.name
                        end
                    end
                    return msg
                end,
                cond = conditions.hide_in_width,
                icon = '  LSP:',
                color = { fg = '#ffffff', gui = 'bold' }
            }

        },
        lualine_x = {
            'encoding', 'fileformat', 'filetype',
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}

-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
-- local lualine = require('lualine')
--
-- -- Color table for highlights
-- -- stylua: ignore
-- local colors = {
--     bg       = '#202328',
--     fg       = '#bbc2cf',
--     yellow   = '#ECBE7B',
--     cyan     = '#008080',
--     darkblue = '#081633',
--     green    = '#98be65',
--     orange   = '#FF8800',
--     violet   = '#a9a1e1',
--     magenta  = '#c678dd',
--     blue     = '#51afef',
--     red      = '#ec5f67',
-- }
--
-- local conditions = {
--     buffer_not_empty = function()
--         return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
--     end,
--     hide_in_width = function()
--         return vim.fn.winwidth(0) > 80
--     end,
--     check_git_workspace = function()
--         local filepath = vim.fn.expand('%:p:h')
--         local gitdir = vim.fn.finddir('.git', filepath .. ';')
--         return gitdir and #gitdir > 0 and #gitdir < #filepath
--     end,
-- }
--
-- -- Config
-- local config = {
--     options = {
--         -- Disable sections and component separators
--         component_separators = '',
--         section_separators = '',
--         theme = {
--             -- We are going to use lualine_c an lualine_x as left and
--             -- right section. Both are highlighted by c theme .  So we
--             -- are just setting default looks o statusline
--             normal = { c = { fg = colors.fg, bg = colors.bg } },
--             inactive = { c = { fg = colors.fg, bg = colors.bg } },
--         },
--         disabled_filetypes = {
--             statusline = { 'oil','AvanteInput', 'Avante', 'AvanteSelectedFiles'},
--             winbar = {},
--         },
--     },
--     sections = {
--         -- these are to remove the defaults
--         lualine_a = {},
--         lualine_b = {},
--         lualine_y = {},
--         lualine_z = {},
--         -- These will be filled later
--         lualine_c = {},
--         lualine_x = {},
--     },
--     inactive_sections = {
--         -- these are to remove the defaults
--         lualine_a = {},
--         lualine_b = {},
--         lualine_y = {},
--         lualine_z = {},
--         lualine_c = {},
--         lualine_x = {},
--     },
-- }
--
-- -- Inserts a component in lualine_c at left section
-- local function ins_left(component)
--     table.insert(config.sections.lualine_c, component)
-- end
--
-- -- Inserts a component in lualine_x at right section
-- local function ins_right(component)
--     table.insert(config.sections.lualine_x, component)
-- end
--
-- ins_left {
--     function()
--         return '▊'
--     end,
--     color = { fg = colors.blue },    -- Sets highlighting of component
--     padding = { left = 0, right = 1 }, -- We don't need space before this
-- }
--
-- ins_left {
--     -- mode component
--     function()
--         return ''
--     end,
--     color = function()
--         -- auto change color according to neovims mode
--         local mode_color = {
--             n = colors.red,
--             i = colors.green,
--             v = colors.blue,
--             [''] = colors.blue,
--             V = colors.blue,
--             c = colors.magenta,
--             no = colors.red,
--             s = colors.orange,
--             S = colors.orange,
--             [''] = colors.orange,
--             ic = colors.yellow,
--             R = colors.violet,
--             Rv = colors.violet,
--             cv = colors.red,
--             ce = colors.red,
--             r = colors.cyan,
--             rm = colors.cyan,
--             ['r?'] = colors.cyan,
--             ['!'] = colors.red,
--             t = colors.red,
--         }
--         return { fg = mode_color[vim.fn.mode()] }
--     end,
--     padding = { right = 1 },
-- }
--
-- ins_left {
--     -- filesize component
--     'filesize',
--     cond = conditions.buffer_not_empty,
-- }
--
-- ins_left {
--     'filename',
--     cond = conditions.buffer_not_empty,
--     color = { fg = colors.magenta, gui = 'bold' },
-- }
--
-- ins_left { 'location' }
--
-- ins_left { 'progress', color = { fg = colors.fg, gui = 'bold' } }
--
-- ins_left {
--     'diagnostics',
--     sources = { 'nvim_diagnostic' },
--     symbols = { error = ' ', warn = ' ', info = ' ' },
--     diagnostics_color = {
--         error = { fg = colors.red },
--         warn = { fg = colors.yellow },
--         info = { fg = colors.cyan },
--     },
-- }
--
-- -- Insert mid section. You can make any number of sections in neovim :)
-- -- for lualine it's any number greater then 2
-- ins_left {
--     function()
--         return '%='
--     end,
-- }
--
-- ins_left {
--     -- Lsp server name .
--     function()
--         local msg = 'No Active Lsp'
--         local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
--         local clients = vim.lsp.get_clients()
--         if next(clients) == nil then
--             return msg
--         end
--         for _, client in ipairs(clients) do
--             local filetypes = client.config.filetypes
--             if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
--                 return client.name
--             end
--         end
--         return msg
--     end,
--     icon = ' LSP:',
--     color = { fg = '#ffffff', gui = 'bold' },
-- }
--
-- -- Add components to right sections
-- ins_right {
--     'o:encoding',     -- option component same as &encoding in viml
--     fmt = string.upper, -- I'm not sure why it's upper case either ;)
--     cond = conditions.hide_in_width,
--     color = { fg = colors.green, gui = 'bold' },
-- }
--
-- ins_right {
--     'fileformat',
--     fmt = string.upper,
--     icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
--     color = { fg = colors.green, gui = 'bold' },
-- }
--
-- ins_right {
--     'branch',
--     icon = '',
--     color = { fg = colors.violet, gui = 'bold' },
-- }
--
-- ins_right {
--     'diff',
--     -- Is it me or the symbol for modified us really weird
--     symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
--     diff_color = {
--         added = { fg = colors.green },
--         modified = { fg = colors.orange },
--         removed = { fg = colors.red },
--     },
--     cond = conditions.hide_in_width,
-- }
--
-- ins_right {
--     function()
--         return '▊'
--     end,
--     color = { fg = colors.blue },
--     padding = { left = 1 },
-- }
--
-- -- Now don't forget to initialize lualine
-- lualine.setup(config)
