local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > 80
    end,
}

local colors = {
    bg       = '#202328',
    fg       = '#bbc2cf',
    yellow   = '#ECBE7B',
    cyan     = '#008080',
    green    = '#98be65',
    orange   = '#FF8800',
    magenta  = '#c678dd',
    red      = '#ec5f67',
    grey     = '#5c6370',
}

local function macro_recording()
    local reg = vim.fn.reg_recording()
    if reg == '' then return '' end
    return ' @' .. reg
end

local function supermaven_status()
    local ok = pcall(require, 'supermaven-nvim.api')
    if not ok then return '' end
    return ''
end

local function supermaven_color()
    local ok, api = pcall(require, 'supermaven-nvim.api')
    if ok and api.is_running() then
        return { fg = colors.green }
    end
    return { fg = colors.grey }
end

local function harpoon_status()
    local ok, mark = pcall(require, 'harpoon.mark')
    if not ok then return '' end
    local total = mark.get_length()
    if not total or total == 0 then return '' end
    local idx = mark.get_current_index()
    return string.format('󰛢 %s/%d', idx or '·', total)
end

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'tokyonight',
        component_separators = '',
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = { 'oil', 'AvanteInput', 'Avante', 'AvanteSelectedFiles', 'trouble', 'AvanteTodos' },
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
            statusline = 500,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = {
            { 'mode', separator = { left = '' }, right_padding = 2 },
        },
        lualine_b = {
            { 'branch' },
            {
                'diff',
                symbols = { added = ' ', modified = ' ', removed = ' ' },
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
                    error = ' ',
                    warn  = ' ',
                    info  = ' '
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
                macro_recording,
                color = { fg = colors.red, gui = 'bold' },
            },
            { 'searchcount' },
        },
        lualine_x = {
            {
                supermaven_status,
                color = supermaven_color,
            },
            {
                require('lazy.status').updates,
                cond = require('lazy.status').has_updates,
                color = { fg = colors.orange },
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
                icon = '  LSP:',
                color = { fg = '#ffffff', gui = 'bold' }
            },
            { 'filetype' },
        },
        lualine_y = {
            {
                harpoon_status,
                color = { fg = colors.cyan },
            },
            { 'progress' },
        },
        lualine_z = {
            { 'location' },
            {
                function() return os.date('%H:%M') end,
                icon = '',
                separator = { right = '' },
                left_padding = 2,
            },
        },
    },
    inactive_sections = {},
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}

-- que el indicador de macro aparezca al instante, sin esperar el refresh
vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave' }, {
    callback = function()
        require('lualine').refresh()
    end,
})
