require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "cssls",
        "ts_ls",
        "pyright",
        "ruff",
        "html",
        "ltex_plus",
    }
})

-- Configurar servidores con la API nativa de Neovim 0.11+
vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            workspace = { checkThirdParty = false },
        },
    },
})
vim.lsp.config("ruff", {
    on_attach = function(client)
        client.server_capabilities.hoverProvider = false -- el hover lo da pyright
    end,
})

-- LTeX+ (LanguageTool): gramática/ortografía + completions + code actions
vim.lsp.config("ltex_plus", {
    on_attach = function()
        require("ltex_extra").setup({
            load_langs = { "es-ES" },
            -- load_langs = { "en-US" },
            path = vim.fn.stdpath("data") .. "/ltex",
        })
    end,
    settings = {
        ltex = {
            language = "es-ES",
            -- language = "en-US",
            completionEnabled = true,
        },
    },
})

vim.lsp.enable({
    "lua_ls",
    "ts_ls",
    "pyright",
    "ruff",
    "cssls",
    "html",
    "ltex_plus",
})

-- Configurar diagnósticos
vim.diagnostic.config({
    virtual_text = false, -- los muestra tiny-inline-diagnostic
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN]  = "",
            [vim.diagnostic.severity.INFO]  = "",
            [vim.diagnostic.severity.HINT]  = "󰌵",
        }
    },
    update_in_insert = false,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
    },
})


-- Autocomandos y keymaps
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        local opts = { buffer = ev.buf }

        vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration,
            vim.tbl_extend("force", opts, { desc = "Declaration" }))
        vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Definition" }))
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation,
            vim.tbl_extend("force", opts, { desc = "Implementation" }))
        vim.keymap.set("n", "<leader>la", vim.lsp.buf.add_workspace_folder,
            vim.tbl_extend("force", opts, { desc = "Add Workspace Folder" }))
        vim.keymap.set("n", "<leader>lr", vim.lsp.buf.remove_workspace_folder,
            vim.tbl_extend("force", opts, { desc = "Remove Workspace Folder" }))
        vim.keymap.set("n", "<leader>ll", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, vim.tbl_extend("force", opts, { desc = "List Workspace Folders" }))
        vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition,
            vim.tbl_extend("force", opts, { desc = "Type Definition" }))
        vim.keymap.set("n", "<leader>lR", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
        vim.keymap.set({ "n", "v" }, "<leader>lc", function() require("tiny-code-action").code_action() end,
            vim.tbl_extend("force", opts, { desc = "Code Action" }))
        vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
        vim.keymap.set("n", "<leader>F", function()
            require("conform").format({ async = true })
        end, vim.tbl_extend("force", opts, { desc = "Format" }))
    end,
})
