require('lazy').setup({
    -- Plenary
    "nvim-lua/plenary.nvim",

    -- NeoTree
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        }
    },

    'nvim-tree/nvim-web-devicons',
    'nvim-lualine/lualine.nvim',

    -- INFO: THEMES --Start--

    -- catppuccin
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {}
    },
    -- gruvbox
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = true,
        opts = {}
    },
    -- tokyo-ngight
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    -- INFO: --End--

    {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    },
    'nvim-treesitter/nvim-treesitter',

    -- cmp
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'saadparwaiz1/cmp_luasnip',

    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp"
    },
    "rafamadriz/friendly-snippets",
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons'
    },
    'terrortylor/nvim-comment',
    {
        'nvim-telescope/telescope.nvim',
        version = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },

    {
        'goolord/alpha-nvim',
        config = function()
            local alpha = require 'alpha'
            local dashboard = require 'alpha.themes.dashboard'
            dashboard.section.header.val = {
                [[  ██╗ ██╗    ███████╗ █████╗ ███╗   ██╗████████╗████████╗██╗ █████╗  ██████╗     ██╗ ██╗  ]],
                [[ ██╔╝██╔╝    ██╔════╝██╔══██╗████╗  ██║╚══██╔══╝╚══██╔══╝██║██╔══██╗██╔════╝     ╚██╗╚██╗ ]],
                [[██╔╝██╔╝     ███████╗███████║██╔██╗ ██║   ██║      ██║   ██║███████║██║  ███╗     ╚██╗╚██╗]],
                [[╚██╗╚██╗     ╚════██║██╔══██║██║╚██╗██║   ██║      ██║   ██║██╔══██║██║   ██║     ██╔╝██╔╝]],
                [[ ╚██╗╚██╗    ███████║██║  ██║██║ ╚████║   ██║      ██║   ██║██║  ██║╚██████╔╝    ██╔╝██╔╝ ]],
                [[  ╚═╝ ╚═╝    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝      ╚═╝   ╚═╝╚═╝  ╚═╝ ╚═════╝     ╚═╝ ╚═╝  ]],

            }
            dashboard.section.buttons.val = {
                dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
                dashboard.button("SPC f f", "󰈞  Find File", ":Telescope fd<CR>"),
                dashboard.button("SPC f r", "󰈢  Recently Opened Files", ":Telescope oldfiles<CR>"),
                dashboard.button("SPC f g", "󰷊  Find Word", ":Telescope live_grep<CR>"),
                dashboard.button("SPC f h", "󰡯  Help Tags", ":Telescope help_tags<CR>"),
                dashboard.button("q", "󰅚  Quit", ":qa<CR>"),
            }
            -- local handle = io.popen('fortune')
            -- local fortune = handle:read("*a")
            -- handle:close()
            -- dashboard.section.footer.val = fortune

            dashboard.config.opts.noautocmd = true
            -- Print a message
            -- vim.cmd [[autocmd User AlphaReady echo 'ready']]

            alpha.setup(dashboard.config)
        end
    },
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end
    },

    'onsails/lspkind-nvim',

    -- Trouble
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
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

    -- NeoDev
    {
        "folke/neodev.nvim", opts = {}
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
                    "neo-tree",
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
    {
        'echasnovski/mini.indentscope', version = '*'
    },

    -- colorizer - NvChad
    'NvChad/nvim-colorizer.lua',

    -- indent-blankline
    {
        "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {}
    },

    -- tailwind-colorizer
    {
        "roobert/tailwindcss-colorizer-cmp.nvim",
        -- optionally, override the default options:
        config = function()
            require("tailwindcss-colorizer-cmp").setup({
                color_square_width = 2,
            })
        end
    },

    -- The best plugin ever
    'eandrju/cellular-automaton.nvim',

    -- flash
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
        -- stylua: ignore
        keys = {
            { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
            { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
            { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
            { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
    },

    -- gitSign
    "lewis6991/gitsigns.nvim",

    -- treeSJ
    {
        'Wansmer/treesj',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            require('treesj').setup({
                use_default_keymaps = false,
                --[[ your config ]]
            })
        end,
    },

    -- BigFile
    "LunarVim/bigfile.nvim",

    'mfussenegger/nvim-dap',

    -- fancy UI for the debugger
    {
        "rcarriga/nvim-dap-ui",
        -- stylua: ignore
        keys = {
            { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
            { "<leader>de", function() require("dapui").eval() end,     desc = "Eval",  mode = { "n", "v" } },
        },
        opts = {},
        config = function(_, opts)
            -- setup dap config by VsCode launch.json file
            -- require("dap.ext.vscode").load_launchjs()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup(opts)
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open({})
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close({})
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close({})
            end
        end,
    },

    -- virtual text for the debugger
    {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
    },
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
    -- AI-SUGGESTION -> SuperMaven
    {
        "supermaven-inc/supermaven-nvim",
    },
})
