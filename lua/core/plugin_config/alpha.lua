local alpha = require 'alpha'
local dashboard = require 'alpha.themes.dashboard'

math.randomseed(vim.uv.hrtime())

local logo = {
    [[ ███████╗ █████╗ ███╗   ██╗████████╗████████╗██╗ █████╗  ██████╗  ]],
    [[ ██╔════╝██╔══██╗████╗  ██║╚══██╔══╝╚══██╔══╝██║██╔══██╗██╔════╝  ]],
    [[ ███████╗███████║██╔██╗ ██║   ██║      ██║   ██║███████║██║  ███╗ ]],
    [[ ╚════██║██╔══██║██║╚██╗██║   ██║      ██║   ██║██╔══██║██║   ██║ ]],
    [[ ███████║██║  ██║██║ ╚████║   ██║      ██║   ██║██║  ██║╚██████╔╝ ]],
    [[ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝      ╚═╝   ╚═╝╚═╝  ╚═╝ ╚═════╝  ]],
}

-- ── Highlights (colores tomados del colorscheme activo) ──────────────
local function fg(name)
    return vim.api.nvim_get_hl(0, { name = name, link = false }).fg or 0xDCD7BA
end

local function mix(a, b, t)
    local function channel(shift)
        local x, y = bit.band(bit.rshift(a, shift), 0xFF), bit.band(bit.rshift(b, shift), 0xFF)
        return bit.lshift(math.floor(x + (y - x) * t + 0.5), shift)
    end
    return channel(16) + channel(8) + channel(0)
end

local function set_hl()
    local accent = fg('Function')
    -- oscuro fijo: Normal tiene guibg=NONE, no hay fondo del que derivarlo
    local surface = mix(fg('Normal'), 0x16161D, 0.85)
    for i = 1, #logo do
        vim.api.nvim_set_hl(0, 'AlphaHeader' .. i,
            { fg = mix(accent, fg('Comment'), (i - 1) / (#logo - 1)) })
    end
    vim.api.nvim_set_hl(0, 'AlphaIcon', { fg = accent })
    vim.api.nvim_set_hl(0, 'AlphaKey', { fg = accent, bg = surface, bold = true })
    vim.api.nvim_set_hl(0, 'AlphaKeyEdge', { fg = surface })
    vim.api.nvim_set_hl(0, 'AlphaGreeting', { fg = fg('Normal') })
    vim.api.nvim_set_hl(0, 'AlphaGit', { link = 'Comment' })
    vim.api.nvim_set_hl(0, 'AlphaFooter', { link = 'Comment' })
    vim.api.nvim_set_hl(0, 'AlphaQuote', { link = 'NonText' })
end
set_hl()
vim.api.nvim_create_autocmd('ColorScheme', { callback = set_hl })

-- ── Botones con keycaps ──────────────────────────────────────────────
local function button(keys, icon, txt, cmd)
    local lhs = table.concat(keys):gsub('󱁐', '<leader>')
    local btn = dashboard.button(lhs, icon .. '  ' .. txt, cmd)

    -- cada tecla es una píldora:  + ' k ' + 
    local sc, hl = '', {}
    for i, key in ipairs(keys) do
        if i > 1 then sc = sc .. ' ' end
        local a = #sc
        local b = a + #''
        local c = b + #key + 2
        sc = sc .. '' .. ' ' .. key .. ' ' .. ''
        vim.list_extend(hl, {
            { 'AlphaKeyEdge', a, b },
            { 'AlphaKey',     b, c },
            { 'AlphaKeyEdge', c, #sc },
        })
    end
    btn.opts.shortcut = sc
    btn.opts.hl_shortcut = hl
    btn.opts.hl = { { 'AlphaIcon', 0, #icon } }
    btn.opts.width = 58
    return btn
end

dashboard.section.buttons.val = {
    button({ 'e' },           '', 'New File',     ':ene <BAR> startinsert <CR>'),
    button({ '󱁐', 'f', 'f' }, '󰈞', 'Find File',    '<cmd>lua require("fff").find_files()<CR>'),
    button({ '󱁐', 'f', 'r' }, '󰈢', 'Recent Files', '<cmd>Telescope oldfiles<CR>'),
    button({ 's' },           '󰦛', 'Restore Session', '<cmd>Persisted load<CR>'),
    button({ '󱁐', 'f', 'g' }, '󰷊', 'Find Word',    '<cmd>lua require("fff").live_grep()<CR>'),
    button({ '󱁐', 'f', 'h' }, '󰡯', 'Help Tags',    '<cmd>Telescope help_tags<CR>'),
    button({ '󱁐', 'e' },      '󰙅', 'Explorer',     '<cmd>Yazi<CR>'),
    button({ '󱁐', 'G' },      '󰊢', 'LazyGit',      '<cmd>LazyGit<CR>'),
    button({ 'l' },           '󰒲', 'Lazy',         '<cmd>Lazy<CR>'),
    button({ 'c' },           '', 'Config',       '<cmd>e $MYVIMRC<CR>'),
    button({ 'q' },           '󰅚', 'Quit',         '<cmd>qa<CR>'),
}

-- ── Header: decrypt una vez al abrir, luego degradado estático ───────
local header = dashboard.section.header
header.val = logo
header.opts.hl = {}
for i = 1, #logo do
    -- fin -1: el largo en bytes cambia mientras dura el glitch
    header.opts.hl[i] = { { 'AlphaHeader' .. i, 0, -1 } }
end

local glitch = vim.fn.split('░▒▓█╗╔╝╚═║', '\\zs')
local timer

local function stop()
    if timer then
        timer:stop()
        timer:close()
        timer = nil
    end
    header.val = logo
end

local function decrypt()
    stop()
    local cells = {}
    for i, line in ipairs(logo) do
        local chars = vim.fn.split(line, '\\zs')
        cells[i] = {}
        for j, ch in ipairs(chars) do
            -- umbral de revelado: barrido izquierda → derecha con ruido
            cells[i][j] = { ch, ch == ' ' and 0 or (j / #chars) * 0.6 + math.random() * 0.4 }
        end
    end

    local frame, frames = 0, 18
    local this = vim.uv.new_timer()
    timer = this
    this:start(0, 35, vim.schedule_wrap(function()
        if timer ~= this then return end -- tick encolado de un timer ya parado
        frame = frame + 1
        if frame >= frames or vim.bo.filetype ~= 'alpha' then
            stop()
        else
            header.val = vim.tbl_map(function(row)
                local out = {}
                for j, cell in ipairs(row) do
                    out[j] = frame / frames >= cell[2] and cell[1] or glitch[math.random(#glitch)]
                end
                return table.concat(out)
            end, cells)
        end
        pcall(alpha.redraw)
    end))
end

vim.api.nvim_create_autocmd('User', { pattern = 'AlphaReady', callback = decrypt })
vim.api.nvim_create_autocmd('User', { pattern = 'AlphaClosed', callback = stop })

-- ── Saludo por hora y línea de Git ───────────────────────────────────
local hour = tonumber(os.date('%H'))
local greeting = {
    type = 'text',
    val = (hour >= 6 and hour < 12 and 'Buenos días'
        or hour >= 12 and hour < 19 and 'Buenas tardes'
        or 'Buenas noches') .. ', Santtiag',
    opts = { position = 'center', hl = 'AlphaGreeting' },
}

-- val vacío al inicio: la línea queda reservada y el layout no salta
local git_line = { type = 'text', val = '', opts = { position = 'center', hl = 'AlphaGit' } }

local function refresh_git()
    vim.system({ 'git', '--no-optional-locks', 'status', '--porcelain', '--branch' }, { text = true },
        vim.schedule_wrap(function(res)
            git_line.val = ''
            if res.code == 0 then
                local lines = vim.split(res.stdout, '\n', { trimempty = true })
                -- se corta por '...' y no por '.': hay ramas como release-1.2
                local branch = lines[1]:sub(4):gsub('%.%.%..*', ''):gsub('^No commits yet on ', '')
                local changes = #lines - 1
                git_line.val = ('󰊢 %s · %s'):format(branch, changes == 0 and 'sin cambios'
                    or changes == 1 and '1 cambio' or changes .. ' cambios')
            end
            if vim.bo.filetype == 'alpha' then pcall(alpha.redraw) end
        end))
end
vim.api.nvim_create_autocmd('User', { pattern = 'AlphaReady', callback = refresh_git })

-- ── Footer: stats de lazy + frase ────────────────────────────────────
local quotes = {
    '"Talk is cheap. Show me the code." — Linus Torvalds',
    '"Simplicity is prerequisite for reliability." — Edsger Dijkstra',
    '"Premature optimization is the root of all evil." — Donald Knuth',
    '"Make it work, make it right, make it fast." — Kent Beck',
    '"Programs must be written for people to read." — Abelson & Sussman',
    '"Controlling complexity is the essence of programming." — Brian Kernighan',
    '"First, solve the problem. Then, write the code." — John Johnson',
    '"Deleted code is debugged code." — Jeff Sickel',
}

dashboard.section.footer.opts.hl = 'AlphaFooter'
vim.api.nvim_create_autocmd('User', {
    pattern = 'LazyVimStarted',
    once = true,
    callback = function()
        local stats = require('lazy').stats()
        local v = vim.version()
        dashboard.section.footer.val = ('⚡ %d/%d plugins en %.0f ms  ·   v%d.%d.%d  ·   %s'):format(
            stats.loaded, stats.count, stats.startuptime, v.major, v.minor, v.patch, os.date('%d %b'))
        pcall(vim.cmd.AlphaRedraw)
    end,
})

-- layout base: padding, header, padding, botones, footer
dashboard.config.layout[3].val = 1
table.insert(dashboard.config.layout, 3, { type = 'padding', val = 1 })
table.insert(dashboard.config.layout, 4, greeting)
table.insert(dashboard.config.layout, 5, git_line)

-- alpha centra cada elemento como bloque, así que la frase va en el suyo
vim.list_extend(dashboard.config.layout, {
    { type = 'padding', val = 1 },
    { type = 'text', val = quotes[math.random(#quotes)], opts = { position = 'center', hl = 'AlphaQuote' } },
})
-- centrado vertical: logo + 1 + saludo y git + 1 + botones (con spacing 1) + footer y frase
local height = #logo + 1 + 2 + 1 + #dashboard.section.buttons.val * 2 - 1 + 3
dashboard.config.layout[1].val = function()
    return math.max(1, math.floor((vim.o.lines - height) / 2) - 1)
end

dashboard.config.opts.noautocmd = true

alpha.setup(dashboard.config)
