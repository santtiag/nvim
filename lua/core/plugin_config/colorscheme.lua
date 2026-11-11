-- El tema se elige con <leader>ft. lazy.nvim carga solo el plugin del tema aplicado.
local file = vim.fn.stdpath('state') .. '/colorscheme'

local function is_light(color)
    local r, g, b = bit.rshift(color, 16), bit.band(bit.rshift(color, 8), 0xFF), bit.band(color, 0xFF)
    return 0.299 * r + 0.587 * g + 0.114 * b > 128
end

-- Resuelve el enlace antes: con :hi, un grupo enlazado perdería su color de texto
local function clear_bg(group)
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    hl.bg = nil
    vim.api.nvim_set_hl(0, group, hl)
end

-- Varios temas siguen 'background': sin esto heredarían el modo claro del anterior
vim.api.nvim_create_autocmd('ColorSchemePre', {
    callback = function()
        vim.o.background = 'dark'
    end,
})

vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function(ev)
        vim.g.colors_name = ev.match -- Kanagawa omite la variante; Telescope la necesita al cancelar
        vim.fn.writefile({ ev.match }, file)

        -- Los temas claros conservan su fondo: su texto no se leería sobre la terminal oscura
        local bg = vim.api.nvim_get_hl(0, { name = 'Normal' }).bg
        if bg and is_light(bg) then
            return
        end
        clear_bg('Normal')
        if not ev.match:match('^kanagawa') then -- Kanagawa conserva su margen sólido
            for _, group in ipairs({ 'NormalNC', 'SignColumn', 'FoldColumn', 'LineNr', 'EndOfBuffer' }) do
                clear_bg(group)
            end
        end
    end,
})

local saved = vim.fn.filereadable(file) == 1 and vim.fn.readfile(file)[1]
if not (saved and pcall(vim.cmd.colorscheme, saved)) then
    vim.cmd.colorscheme('kanagawa-wave')
end
