require("ibl").setup({
    indent = {
        -- char = "▏",
        char = "│",
        -- tab_char = "▏",
        tab_char = "│",
    },
    scope = { enabled = false },
    exclude = {
        filetypes = {
            "help",
            "alpha",
            "dashboard",
            "neo-tree",
            "Trouble",
            "trouble",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "lazyterm",
        },
    },
})

