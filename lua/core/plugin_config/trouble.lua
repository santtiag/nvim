require('trouble').setup({
    signs = {
        -- icons / text used for a diagnostic
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "☂ ",
    },
})

vim.keymap.set("n", "xx", function() require("trouble").toggle() end, {desc = 'Toggle'})
vim.keymap.set("n", "xw", function() require("trouble").toggle("workspace_diagnostics") end, {desc = 'Workspace Diagnostics'})
vim.keymap.set("n", "xd", function() require("trouble").toggle("document_diagnostics") end, {desc = 'Document Diagnostics'})
vim.keymap.set("n", "xq", function() require("trouble").toggle("quickfix") end, {desc = 'QuickFix'})
vim.keymap.set("n", "xl", function() require("trouble").toggle("loclist") end, {desc = 'Loclist'})
vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end, {desc = 'Lsp References'})

