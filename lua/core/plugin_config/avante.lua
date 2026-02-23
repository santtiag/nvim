return {
    "yetone/avante.nvim",
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- ⚠️ must add this setting! ! !
    build = vim.fn.has("win32") ~= 0
        and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        or "make",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
        -- add any opts here
        -- this file can contain specific instructions for your project
        -- instructions_file = "avante.md",
        provider = "openrouter",
        providers = {
            openrouter = {
                __inherited_from = "openai",
                endpoint = "https://openrouter.ai/api/v1",
                -- model = "deepseek/deepseek-v3.2",
                model = "minimax/minimax-m2.1",
                timeout = 40000, -- Timeout in milliseconds
                extra_request_body = {
                    temperature = 0.75,
                    max_tokens = 65480,
                },
                api_key_name = "OPENROUTER_API_KEY"
            },
        },
        windows = {
            position = "right", -- the position of the sidebar
            wrap = true,      -- similar to vim.o.wrap
            width = 42,       -- default % based on available width
            sidebar_header = {
                enabled = true, -- true, false to enable/disable the header
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
        }
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "nvim-mini/mini.pick",           -- for file_selector provider mini.pick
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
        "ibhagwan/fzf-lua",              -- for file_selector provider fzf
        "stevearc/dressing.nvim",        -- for input provider dressing
        "folke/snacks.nvim",             -- for input provider snacks
        "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
        {
            -- Make sure to set this up properly if you have lazy=true
            'MeanderingProgrammer/render-markdown.nvim',
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },

}
