-- Solo lo que dropbar y heirline no muestran por ventana:
-- diagnósticos, cambios de git y si el buffer está modificado.
local severities = { 'Error', 'Warn', 'Info', 'Hint' }
local git_stats = {
    { 'added',   '+', 'GitSignsAdd' },
    { 'changed', '~', 'GitSignsChange' },
    { 'removed', '-', 'GitSignsDelete' },
}

require('incline').setup({
    window = {
        margin = { horizontal = 3, vertical = 0 }, -- deja libre la columna de satellite
        overlap = { winbar = true },
    },
    hide = { cursorline = false },
    ignore = { filetypes = { 'alpha' } },
    render = function(props)
        local out = {}

        local counts = vim.diagnostic.count(props.buf)
        for severity, name in ipairs(severities) do
            if counts[severity] then
                local icon = vim.diagnostic.config().signs.text[severity]
                out[#out + 1] = { icon .. ' ' .. counts[severity] .. ' ', group = 'Diagnostic' .. name }
            end
        end

        local git = vim.b[props.buf].gitsigns_status_dict or {}
        for _, stat in ipairs(git_stats) do
            if (git[stat[1]] or 0) > 0 then
                out[#out + 1] = { stat[2] .. git[stat[1]] .. ' ', group = stat[3] }
            end
        end

        if vim.bo[props.buf].modified then
            out[#out + 1] = { '● ', group = 'Function' }
        end

        return #out > 0 and out or nil -- nil la oculta
    end,
})
