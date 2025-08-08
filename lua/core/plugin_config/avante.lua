    return {
    auto_suggestions_provider = "cerebras",
    provider = "cerebras",
    providers = {
        cerebras = {
            __inherited_from = 'openai',
            api_key_name = "CEREBRAS_API_KEY",
            endpoint = "https://api.cerebras.ai/v1", -- Endpoint
            model = "qwen-3-coder-480b",
            -- model = "qwen-3-235b-a22b-instruct-2507", -- Model
            max_tokens = 64000,
        }
    },
    windows = {
        position = "right",   -- the position of the sidebar
        wrap = true,          -- similar to vim.o.wrap
        width = 42,           -- default % based on available width
        sidebar_header = {
            enabled = true,   -- true, false to enable/disable the header
            align = "center", -- left, center, right for title
            rounded = true,
        },
        input = {
            prefix = "> ",
            height = 10, -- Height of the input window in vertical layout
        },
    },
    mappings = {
        diff = {
            ours = "co",
            theirs = "ct",
            all_theirs = "ca",
            both = "cb",
            cursor = "cc",
            next = "]x",
            prev = "[x",
        },
        suggestion = {
            accept = "<C-l>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-j>",
        },
        jump = {
            next = "]]",
            prev = "[[",
        },
        submit = {
            normal = "<CR>",
            insert = "<C-s>",
        },
        cancel = {
            normal = { "<C-c>", "<Esc>", "q" },
            insert = { "<C-c>" },
        },
        sidebar = {
            apply_all = "A",
            apply_cursor = "a",
            retry_user_request = "r",
            edit_user_request = "e",
            switch_windows = "<Tab>",
            reverse_switch_windows = "<S-Tab>",
            remove_file = "dd",
            add_file = "@",
            close = { "<Esc>", "q" },
            close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
        },
    },
}
