require('lazy').setup({
    'nvim-lua/plenary.nvim', -- plenary

    'ThePrimeagen/harpoon',  -- harpoon

    'nvim-tree/nvim-web-devicons',


    -- config
    'neovim/nvim-lspconfig',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',

    -- snippets
    {
        "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp"
    },
    'saadparwaiz1/cmp_luasnip',
    'rafamadriz/friendly-snippets',
    'onsails/lspkind-nvim', -- icons

    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        }
    },

    {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {}
    },

    -- NOTE: ---THEMES ---
    { "catppuccin/nvim",          name = "catppuccin", priority = 1000, opts = {} }, -- catppuccin
    { "ellisonleao/gruvbox.nvim", priority = 1000,     config = true,   opts = {} }, -- gruvbox
    { "folke/tokyonight.nvim",    lazy = false,        priority = 1000, opts = {} }, -- tokyo-ngight

    'nvim-treesitter/nvim-treesitter',

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    -- MarkdownPreview
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },

    -- Alpha
    {
        'goolord/alpha-nvim',
        -- dependencies = { 'echasnovski/mini.icons' },
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local startify = require("alpha.themes.startify")
            startify.file_icons.provider = "devicons"
            require("alpha").setup(
                startify.config
            )
        end,
    },

    -- Which-key
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 250
        end
    },

    -- Notify
    'rcarriga/nvim-notify',

    -- Nui
    'MunifTanjim/nui.nvim',

    -- Cmd Noice
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- add any options here
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        }
    },

    -- lazydev
    {
        {
            "folke/lazydev.nvim",
            ft = "lua", -- only load on lua files
            opts = {
                library = {
                    -- See the configuration section for more details
                    -- Load luvit types when the `vim.uv` word is found
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                },
            },
        },
        { -- optional cmp completion source for require statements and module annotations
            "hrsh7th/nvim-cmp",
            opts = function(_, opts)
                opts.sources = opts.sources or {}
                table.insert(opts.sources, {
                    name = "lazydev",
                    group_index = 0, -- set group index to 0 to skip loading LuaLS completions
                })
            end,
        },
    },

    -- Mini
    {
        'echasnovski/mini.pairs', version = '*'
    },
    {
        'echasnovski/mini.surround', version = '*'
    },
    {
        'echasnovski/mini.cursorword', version = '*'
    },
    {
        'echasnovski/mini.indentscope',
        version = '*',
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "help",
                    "alpha",
                    "dashboard",
                    "Trouble",
                    "trouble",
                    "lazy",
                    "mason",
                    "notify",
                    "toggleterm",
                    "lazyterm",
                },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,

    },

    -- Colorizer - NvChad
    'NvChad/nvim-colorizer.lua',

    -- Indent-blankline
    {
        "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {}
    },

    -- Tailwind-colorizer
    {
        "roobert/tailwindcss-colorizer-cmp.nvim",
        -- optionally, override the default options:
        config = function()
            require("tailwindcss-colorizer-cmp").setup({
                color_square_width = 2,
            })
        end
    },

    -- Flash
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
        -- stylua: ignore
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            -- { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
            -- { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            -- { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
    },

    -- GitSign
    "lewis6991/gitsigns.nvim",

    -- Lazy Git
    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        -- setting the keybinding for LazyGit with 'keys' is recommended in
        -- order to load the plugin when the command is run for the first time
        keys = {
            { "<leader>G", "<cmd>LazyGit<cr>", desc = "LazyGit" }
        }
    },

    -- Todo Comments
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },

    -- breadcrumbs
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons", -- optional dependency
        },
        opts = {
            -- configurations go here
        },
    },

    -- Oil
    {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {},
        dependencies = { { "echasnovski/mini.icons", opts = {} } },
        lazy = false,
    },

    -- Twilight Nvim
    {
        "folke/twilight.nvim",
        opts = {
        }
    },

    -- Rip Substitute
    {
        "chrisgrieser/nvim-rip-substitute",
        cmd = "RipSubstitute",
        opts = {},
    },

    -- Goto
    {
        "rmagatti/goto-preview",
        event = "BufEnter",
        config = true, -- necessary as per https://github.com/rmagatti/goto-preview/issues/88
    },

    -- Trouble
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
    },

    -- Avante
    require("core.plugin_config.avante"),
})
