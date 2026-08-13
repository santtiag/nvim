local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
    end,
    hide_in_width = function()
        return vim.o.columns > 100
    end,
}

local colors = {
    yellow  = '#ECBE7B',
    cyan    = '#008080',
    green   = '#98be65',
    orange  = '#FF8800',
    magenta = '#c678dd',
    red     = '#ec5f67',
    grey    = '#5c6370',
}

local augroup = vim.api.nvim_create_augroup('user.lualine', {})

local mode_icons = {
    NORMAL     = ' ',
    INSERT     = ' ',
    VISUAL     = '󰈈 ',
    ['V-LINE'] = '󰈈 ',
    ['V-BLOCK'] = '󰈈 ',
    COMMAND    = ' ',
    REPLACE    = ' ',
    TERMINAL   = ' ',
    SELECT     = '󰒉 ',
}

local function mode_fmt(str)
    return (mode_icons[str] or '') .. str
end

local lsp_icons = {
    lua_ls        = ' ',
    pyright       = ' ',
    basedpyright  = ' ',
    ts_ls         = ' ',
    rust_analyzer = ' ',
    gopls         = ' ',
    clangd        = ' ',
    bashls        = ' ',
    jsonls        = ' ',
    html          = ' ',
    cssls         = ' ',
    lazydev       = ' ',
}

local function lsp_status()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then return '' end
    local parts = {}
    for _, client in ipairs(clients) do
        table.insert(parts, (lsp_icons[client.name] or '󰒋 ') .. client.name)
    end
    return table.concat(parts, ' ')
end

local git_arrows = ''

local function update_git_arrows()
    vim.system(
        { 'git', 'rev-list', '--left-right', '--count', 'HEAD...@{upstream}' },
        { text = true },
        function(out)
            local result = ''
            if out.code == 0 and out.stdout then
                local ahead, behind = out.stdout:match('(%d+)%s+(%d+)')
                if ahead and behind then
                    local parts = {}
                    if ahead ~= '0' then table.insert(parts, '↑' .. ahead) end
                    if behind ~= '0' then table.insert(parts, '↓' .. behind) end
                    result = table.concat(parts, ' ')
                end
            end
            vim.schedule(function()
                if git_arrows == result then return end
                git_arrows = result
                pcall(require('lualine').refresh)
            end)
        end
    )
end

vim.api.nvim_create_autocmd({ 'FocusGained', 'BufWritePost', 'DirChanged', 'VimEnter' }, {
    group = augroup,
    callback = update_git_arrows,
})
update_git_arrows()

local function macro_recording()
    local reg = vim.fn.reg_recording()
    if reg == '' then return '' end
    return ' @' .. reg
end

local function harpoon_status()
    local mark = package.loaded['harpoon.mark']
    if not mark then return '' end
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
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        },
    },
    sections = {
        lualine_a = {
            { 'mode', fmt = mode_fmt, separator = { left = '' }, right_padding = 2 },
        },
        lualine_b = {
            { 'branch' },
            {
                function() return git_arrows end,
                color = { fg = colors.cyan },
                padding = { left = 0, right = 1 },
            },
            {
                'diff',
                symbols = { added = ' ', modified = ' ', removed = ' ' },
                diff_color = {
                    added = { fg = colors.green },
                    modified = { fg = colors.orange },
                    removed = { fg = colors.red },
                },
            },
        },
        lualine_c = {
            {
                'filename',
                path = 1,
                symbols = { modified = ' ●', readonly = ' ', unnamed = '' },
                cond = conditions.buffer_not_empty,
                color = { fg = colors.magenta, gui = 'bold' },
            },
            {
                macro_recording,
                color = { fg = colors.red, gui = 'bold' },
            },
            { 'searchcount' },
            { 'selectioncount' },
        },
        lualine_x = {
            {
                lsp_status,
                cond = conditions.hide_in_width,
                color = { fg = '#ffffff', gui = 'bold' },
            },
            {
                'diagnostics',
                sources = { 'nvim_diagnostic' },
                symbols = {
                    error = ' ',
                    warn  = ' ',
                    info  = ' ',
                    hint  = '󰌵 ',
                },
                diagnostics_color = {
                    error = { fg = colors.red },
                    warn  = { fg = colors.yellow },
                    info  = { fg = colors.cyan },
                    hint  = { fg = colors.grey },
                },
                cond = conditions.hide_in_width,
            },
            {
                require('lazy.status').updates,
                cond = require('lazy.status').has_updates,
                color = { fg = colors.orange },
            },
            { 'filetype' },
        },
        lualine_y = {
            {
                harpoon_status,
                color = { fg = colors.cyan },
            },
            { 'progress' },
            { 'encoding', cond = conditions.hide_in_width },
            {
                'fileformat',
                symbols = { unix = '', dos = '', mac = '' },
                cond = conditions.hide_in_width,
            },
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
    extensions = { 'lazy', 'mason' },
}

vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave' }, {
    group = augroup,
    callback = function()
        require('lualine').refresh()
    end,
})
