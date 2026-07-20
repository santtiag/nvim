-- Cada plugin carga su config desde lua/core/plugin_config/ mediante
-- config = require(...), disparado por su event/cmd/keys — no al arranque.
local function use(module)
    return function()
        require('core.plugin_config.' .. module)
    end
end

require('lazy').setup({
    -- libs
    { 'nvim-lua/plenary.nvim',   lazy = true },
    { 'MunifTanjim/nui.nvim',    lazy = true },
    {
        'nvim-tree/nvim-web-devicons',
        lazy = true,
        config = use('nvim-web-devicons'),
    },

    -- NOTE: --- THEMES ---
    {
        'folke/tokyonight.nvim',
        lazy = false,
        priority = 1000,
        config = use('themes.tokyo-night'),
    },
    { 'catppuccin/nvim',          name = 'catppuccin', lazy = true },
    { 'ellisonleao/gruvbox.nvim', lazy = true },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'hrsh7th/cmp-nvim-lsp',
        },
        config = function()
            require('core.plugin_config.mason')
            require('core.plugin_config.lsp_config')
        end,
    },

    -- Completion + snippets
    {
        'hrsh7th/nvim-cmp',
        event = { 'InsertEnter', 'CmdlineEnter' },
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            {
                'L3MON4D3/LuaSnip',
                version = 'v2.*',
                build = 'make install_jsregexp',
            },
            'saadparwaiz1/cmp_luasnip',
            'rafamadriz/friendly-snippets',
            'onsails/lspkind-nvim',
        },
        config = use('completions'),
    },

    -- lazydev
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            },
        },
    },

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        event = { 'BufReadPost', 'BufNewFile' },
        config = use('treesitter'),
    },

    -- Statusline
    {
        'nvim-lualine/lualine.nvim',
        event = 'VeryLazy',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = use('lualine'),
    },

    -- Which-key
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 250
            require('core.plugin_config.which-key')
        end,
    },

    -- Cmd Noice
    {
        'folke/noice.nvim',
        event = 'VeryLazy',
        dependencies = {
            'MunifTanjim/nui.nvim',
            {
                'rcarriga/nvim-notify',
                config = use('notify'),
            },
        },
        config = use('noice'),
    },

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        version = '*',
        cmd = 'Telescope',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        },
    },

    -- Fzf
    {
        'ibhagwan/fzf-lua',
        cmd = 'FzfLua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {},
    },

    -- Harpoon (cargado on demand por los mappings de which-key)
    { 'ThePrimeagen/harpoon', lazy = true },

    -- MarkdownPreview
    {
        'iamcco/markdown-preview.nvim',
        cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
        build = 'cd app && yarn install',
        init = function()
            vim.g.mkdp_filetypes = { 'markdown' }
        end,
        ft = { 'markdown' },
    },

    -- Alpha (dashboard)
    {
        'goolord/alpha-nvim',
        event = 'VimEnter',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = use('alpha'),
    },

    -- Mini
    {
        'echasnovski/mini.pairs',
        version = '*',
        event = 'InsertEnter',
        config = use('mini-pairs'),
    },
    {
        'echasnovski/mini.surround',
        version = '*',
        event = 'VeryLazy',
        config = use('mini-surround'),
    },
    {
        'echasnovski/mini.cursorword',
        version = '*',
        event = { 'BufReadPost', 'BufNewFile' },
        config = use('mini-cursorword'),
    },
    {
        'echasnovski/mini.indentscope',
        version = '*',
        event = { 'BufReadPost', 'BufNewFile' },
        config = use('mini-indent-scope'),
        init = function()
            vim.api.nvim_create_autocmd('FileType', {
                group = vim.api.nvim_create_augroup('user.miniindentscope', {}),
                pattern = {
                    'help', 'alpha', 'dashboard', 'Trouble', 'trouble',
                    'lazy', 'mason', 'notify', 'toggleterm', 'lazyterm',
                },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
    },

    -- Colorizer - NvChad
    {
        'NvChad/nvim-colorizer.lua',
        event = { 'BufReadPost', 'BufNewFile' },
        config = use('colorizer'),
    },

    -- Indent-blankline
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        event = { 'BufReadPost', 'BufNewFile' },
        config = use('indent-blankline'),
    },

    -- Flash
    {
        'folke/flash.nvim',
        event = 'VeryLazy',
        ---@type Flash.Config
        opts = {},
        -- stylua: ignore
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        },
    },

    -- GitSign
    {
        'lewis6991/gitsigns.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        config = use('gitsign'),
    },

    -- Lazy Git
    {
        'kdheepak/lazygit.nvim',
        lazy = true,
        cmd = {
            'LazyGit',
            'LazyGitConfig',
            'LazyGitCurrentFile',
            'LazyGitFilter',
            'LazyGitFilterCurrentFile',
        },
        dependencies = { 'nvim-lua/plenary.nvim' },
        keys = {
            { '<leader>G', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
        },
    },

    -- Todo Comments
    {
        'folke/todo-comments.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {},
    },

    -- breadcrumbs
    {
        'utilyre/barbecue.nvim',
        name = 'barbecue',
        version = '*',
        event = { 'BufReadPost', 'BufNewFile' },
        dependencies = {
            'SmiteshP/nvim-navic',
            'nvim-tree/nvim-web-devicons',
        },
        config = use('breadcrumbs'),
    },

    -- Oil
    {
        'stevearc/oil.nvim',
        lazy = false,
        dependencies = { { 'echasnovski/mini.icons', opts = {} } },
        config = use('oil'),
    },

    -- Twilight Nvim
    {
        'folke/twilight.nvim',
        lazy = true,
        cmd = 'Twilight',
        opts = {},
    },

    -- Rip Substitute
    {
        'chrisgrieser/nvim-rip-substitute',
        lazy = true,
        cmd = 'RipSubstitute',
        opts = {},
    },

    -- Goto
    {
        'rmagatti/goto-preview',
        lazy = true, -- cargado por los mappings <leader>g* de which-key
        config = true,
    },

    -- Trouble
    {
        'folke/trouble.nvim',
        cmd = 'Trouble',
        opts = {},
    },

    -- autosuggestion ai
    {
        'supermaven-inc/supermaven-nvim',
        event = 'InsertEnter',
        config = function()
            require('supermaven-nvim').setup({
                keymaps = {
                    accept_suggestion = '<C-}>',
                },
            })
        end,
    },
})
