local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require('lspkind')

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },

    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-o>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
    }),

    sources = cmp.config.sources(
        {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'path' },
        },
        {
            { name = 'buffer' },
        }
    ),
    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol_text", -- muestra icono + texto
            maxwidth = 50,
            ellipsis_char = "...",
            menu = {
                nvim_lsp = "󰘦",
                luasnip  = "󰠠",
                buffer   = "󰽘",
                path     = "",
            },
        }),

        -- format = function(entry, vim_item)
        --     vim_item.kind = string.format('%s %s', lspkind.presets.default[vim_item.kind], vim_item.kind)
        --     vim_item.menu = ({
        --         nvim_lsp = '󰞶',
        --         nvim_lua = "",
        --         zsh = "",
        --         luasnip = '',
        --         -- vsnip = "",
        --         path = "󰝰",
        --         buffer = "󰽘",
        --         treesitter = "",
        --     })[entry.source.name]
        --     return vim_item
        -- end,
    },
})

-- Completado para `/` y `:`
cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = "buffer" } },
})

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
})
