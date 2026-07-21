require('blink.cmp').setup({
    -- 'default' <Tab>/<S-Tab> navegan, <CR> confirma
    keymap = {
        preset = 'default',
        ['<CR>'] = { 'accept', 'fallback' },
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<C-o>'] = { 'show', 'fallback' },
        ['<C-e>'] = { 'hide', 'fallback' },
        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
    },

    appearance = {
        nerd_font_variant = 'mono',
    },

    completion = {
        menu = {
            border = 'rounded',
            draw = { columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'source_name' } } },
        },
        documentation = {
            auto_show = true,
            window = { border = 'rounded' },
        },
    },

    snippets = { preset = 'default' }, -- usa vim.snippet + friendly-snippets

    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
        providers = {
            lazydev = {
                name = 'LazyDev',
                module = 'lazydev.integrations.blink',
                score_offset = 100,
            },
        },
    },

    -- motor de fuzzy en Rust
    fuzzy = { implementation = 'prefer_rust_with_warning' },
})
