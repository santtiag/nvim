require("noice").setup({
    cmdline = {
        enabled = true,
        view = "cmdline_popup",
        format = {
            cmdline = { title = " Comando " },
            filter = { title = " Shell " },
            lua = { title = " Lua " },
            help = { title = " Ayuda " },
            calculator = { title = " Calculadora " },
        },
    },
    routes = {
        -- tiny-glimmer lo imprime siempre; saldría por cada tema de la vista previa
        { filter = { event = "msg_show", find = "TinyGlimmer: Reloading" }, opts = { skip = true } },
    },
    presets = {
        bottom_search = true,     -- use a classic bottom cmdline for search
        command_palette = true,   -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,       -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false,   -- add a border to hover docs and signature help
    },
})

-- Borde e icono con el mismo acento azul del dashboard
local function set_hl()
    vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { link = "Function" })
    vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { link = "Function" })
end
set_hl()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_hl })
