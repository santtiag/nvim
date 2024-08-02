require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all"
    ensure_installed = { 'lua', 'javascript', 'typescript', 'python', 'css', 'html', 'rust'  },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    auto_install = true,
    rainbow = {},

    highlight = { enable = true,
        -- disable = { '' },
    }
}

