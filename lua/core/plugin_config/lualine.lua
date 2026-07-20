local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > 80
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

-- ── Modo con icono ──────────────────────────────────────────────────
local mode_icons = {
    NORMAL   = ' ',
    INSERT   = ' ',
    VISUAL   = '󰈈 ',
    ['V-LINE'] = '󰈈 ',
    ['V-BLOCK'] = '󰈈 ',
    COMMAND  = ' ',
    REPLACE  = ' ',
    TERMINAL = ' ',
    SELECT   = '󰒉 ',
}

local function mode_fmt(str)
    return (mode_icons[str] or '') .. str
end

-- ── LSP: nombre cacheado por buffer + icono por servidor ────────────
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
}

vim.api.nvim_create_autocmd({ 'LspAttach', 'LspDetach' }, {
    group = augroup,
    callback = function(ev)
        local clients = vim.lsp.get_clients({ bufnr = ev.buf })
        local names = {}
        for _, client in ipairs(clients) do
            if ev.event ~= 'LspDetach' or client.id ~= ev.data.client_id then
                table.insert(names, client.name)
            end
        end
        vim.b[ev.buf].lsp_name = names[1]
    end,
})

-- por si el servidor ya estaba adjunto antes de que cargara lualine
do
    local client = vim.lsp.get_clients({ bufnr = 0 })[1]
    if client then vim.b.lsp_name = client.name end
end

local function lsp_status()
    local name = vim.b.lsp_name
    if not name then return '' end
    return (lsp_icons[name] or ' ') .. name
end

-- ── Git ahead/behind: async, cacheado, sin git por render ───────────
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
            git_arrows = result
        end
    )
end

vim.api.nvim_create_autocmd({ 'FocusGained', 'BufWritePost', 'DirChanged', 'VimEnter' }, {
    group = augroup,
    callback = update_git_arrows,
})
update_git_arrows()

-- ── Macro / Supermaven / Harpoon ────────────────────────────────────
local function macro_recording()
    local reg = vim.fn.reg_recording()
    if reg == '' then return '' end
    return ' @' .. reg
end

-- package.loaded en vez de require: no fuerza la carga lazy del plugin
local function supermaven_status()
    if not package.loaded['supermaven-nvim'] then return '' end
    return ''
end

local function supermaven_color()
    local api = package.loaded['supermaven-nvim.api']
    if api and api.is_running() then
        return { fg = colors.green }
    end
    return { fg = colors.grey }
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
            statusline = { 'oil', 'trouble' },
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
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
                lsp_status,
                cond = conditions.hide_in_width,
                color = { fg = '#ffffff', gui = 'bold' },
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
    group = augroup,
    callback = function()
        require('lualine').refresh()
    end,
})
