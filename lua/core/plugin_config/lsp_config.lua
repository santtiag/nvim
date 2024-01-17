require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "cssls", "tsserver", "pyright", "html", "angularls" }
})

local lspconfig = require('lspconfig')

local lsp_defaults = lspconfig.util.default_config

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
lsp_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lsp_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

require("lspconfig").lua_ls.setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = {
                    [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                    [vim.fn.stdpath "config" .. "/lua"] = true,
                },
            },
        },
    }
}

require 'lspconfig'.angularls.setup {}
require('lspconfig').tsserver.setup({})
require('lspconfig').pyright.setup({})
require('lspconfig').cssls.setup({
    capabilities = capabilities
})
require('lspconfig').html.setup({
    capabilities = capabilities,
})
require 'lspconfig'.lua_ls.setup {}
require 'lspconfig'.tailwindcss.setup {}

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', '<leader>lD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = 'Declaration' }))
        vim.keymap.set('n', '<leader>ld', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = 'Definition' }))
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>li', vim.lsp.buf.implementation, vim.tbl_extend('force', opts, { desc = 'Implementation' }))
        vim.keymap.set('n', '<leader>la', vim.lsp.buf.add_workspace_folder, vim.tbl_extend('force', opts, { desc = 'Add Workspace Folder' }))
        vim.keymap.set('n', '<leader>lr', vim.lsp.buf.remove_workspace_folder, vim.tbl_extend('force', opts, { desc = 'Remove Workspace Folder' }))
        vim.keymap.set('n', '<leader>ll', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, vim.tbl_extend('force', opts, { desc = 'List Workspace Folders' }))
        vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition, vim.tbl_extend('force', opts, { desc = 'Type Definition' }))
        vim.keymap.set('n', '<leader>lR', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'Rename' }))
        vim.keymap.set({ 'n', 'v' }, '<leader>lc', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'Code Action' }))
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('force', opts, { desc = 'References' }))
        vim.keymap.set('n', '<leader>F', function()
            vim.lsp.buf.format({ async = true })
        end, vim.tbl_extend('force', opts, { desc = 'Format' }))
    end,
})

vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })
vim.diagnostic.config({
    virtual_text = {
        prefix = '●',
    }
})

