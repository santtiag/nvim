-- nvim-treesitter branch `main`: los parsers se instalan con :TSInstall /
-- ts.install(), y el highlight se activa por buffer con vim.treesitter.start().
local ts = require('nvim-treesitter')

-- instalar solo los parsers que falten (install() con la lista completa
-- relanza descargas en cada arranque)
local wanted = { 'lua', 'javascript', 'typescript', 'python', 'css', 'html', 'rust' }
local missing = {}
for _, lang in ipairs(wanted) do
    if #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', true) == 0 then
        table.insert(missing, lang)
    end
end
if #missing > 0 then
    ts.install(missing)
end

local group = vim.api.nvim_create_augroup('user.treesitter', {})

local function start_highlight(buf)
    -- sin highlight en archivos grandes (>100KB)
    local name = vim.api.nvim_buf_get_name(buf)
    local ok, stat = pcall(vim.uv.fs_stat, name)
    if ok and stat and stat.size > 100 * 1024 then
        return
    end
    pcall(vim.treesitter.start, buf) -- no-op si no hay parser para el filetype
end

vim.api.nvim_create_autocmd('FileType', {
    group = group,
    callback = function(ev)
        start_highlight(ev.buf)
    end,
})

-- el buffer que disparó la carga ya pasó su FileType
start_highlight(vim.api.nvim_get_current_buf())
