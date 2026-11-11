-- Cada plugin carga su config desde lua/core/plugin_config/ mediante
-- config = require(...), disparado por su event/cmd/keys — no al arranque.
local function use(module)
    return function()
        require('core.plugin_config.' .. module)
    end
end

require('lazy').setup({
    -- libs
    { 'nvim-lua/plenary.nvim', lazy = true },
    { 'MunifTanjim/nui.nvim',  lazy = true },
    {
        'nvim-tree/nvim-web-devicons',
        lazy = true,
        config = use('nvim-web-devicons'),
    },

    -- NOTE: --- THEMES ---
    {
        'folke/tokyonight.nvim',
        lazy = true,
        config = use('themes.tokyo-night'),
    },
    { 'catppuccin/nvim',          name = 'catppuccin', lazy = true, config = use('themes.catppuccin') },
    { 'ellisonleao/gruvbox.nvim', lazy = true,         config = use('themes.gruvbox') },
    { 'rebelot/kanagawa.nvim',    lazy = true },
    -- Aparecen solos en <leader>ft; añadir un tema es añadir una línea
    { 'rose-pine/neovim',              name = 'rose-pine', lazy = true },
    { 'EdenEast/nightfox.nvim',        lazy = true },
    { 'navarasu/onedark.nvim',         lazy = true },
    { 'Mofiqul/dracula.nvim',          lazy = true },
    { 'gbprod/nord.nvim',              lazy = true },
    { 'sainnhe/everforest',            lazy = true },
    { 'sainnhe/gruvbox-material',      lazy = true },
    { 'sainnhe/sonokai',               lazy = true },
    { 'projekt0n/github-nvim-theme',   name = 'github-theme', lazy = true },
    { 'Shatur/neovim-ayu',             lazy = true },
    { 'vague-theme/vague.nvim',        lazy = true },
    { 'scottmckendry/cyberdream.nvim', lazy = true },
    { 'bluz71/vim-moonfly-colors',     name = 'moonfly', lazy = true },
    { 'bluz71/vim-nightfly-colors',    name = 'nightfly', lazy = true },
    { 'savq/melange-nvim',             lazy = true },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            'mason-org/mason.nvim',
            'mason-org/mason-lspconfig.nvim',
            -- Code actions de LTeX+ (diccionario, desactivar regla, falsos positivos)
            'barreiroleo/ltex_extra.nvim',
        },
        config = function()
            require('core.plugin_config.mason')
            require('core.plugin_config.lsp_config')
        end,
    },

    -- Completion + snippets
    {
        'saghen/blink.cmp',
        version = '1.*', -- release con binarios precompilados (sin build de Rust)
        event = { 'InsertEnter', 'CmdlineEnter' },
        dependencies = { 'rafamadriz/friendly-snippets' },
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
        'rebelot/heirline.nvim',
        event = 'UiEnter',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = use('heirline'),
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
        config = function()
            require('telescope').load_extension('fzf')
        end,
    },

    -- fff: archivos y grep (Telescope sigue para ayuda, recientes y buffers)
    {
        'dmtrKovalenko/fff',
        build = function()
            require('fff.download').download_or_build_binary()
        end,
        lazy = false, -- se inicializa de forma diferida por su cuenta
        opts = {},
    },

    -- Vista previa de Markdown en el navegador (Lua puro, sin Node ni build)
    {
        'brianhuster/live-preview.nvim',
        cmd = 'LivePreview',
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
        'nvim-mini/mini.pairs',
        version = '*',
        event = 'InsertEnter',
        config = use('mini-pairs'),
    },
    {
        'nvim-mini/mini.surround',
        version = '*',
        event = 'VeryLazy',
        config = use('mini-surround'),
    },
    {
        'nvim-mini/mini.cursorword',
        version = '*',
        event = { 'BufReadPost', 'BufNewFile' },
        config = use('mini-cursorword'),
    },
    {
        'nvim-mini/mini.indentscope',
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
        'catgoose/nvim-colorizer.lua',
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
        'Bekaboo/dropbar.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        dependencies = {
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        },
    },

    -- yazi (mapeos en which-key)
    {
        'mikavilpas/yazi.nvim',
        version = '*',
        lazy = true,
        cmd = 'Yazi',
        dependencies = { { 'nvim-lua/plenary.nvim', lazy = true } },
        init = function()
            -- El snap publica el CLI como `yazi.ya`; yazi.nvim busca `ya` en PATH.
            if vim.fn.executable('ya') == 0 then
                local snap_dir = '/snap/yazi/current'
                if vim.fn.filereadable(snap_dir .. '/ya') == 1 then
                    vim.env.PATH = snap_dir .. ':' .. vim.env.PATH
                end
            end
        end,
        opts = {
            yazi_floating_window_border = 'rounded',
        },
    },

    -- Rip Substitute
    {
        'chrisgrieser/nvim-rip-substitute',
        lazy = true,
        cmd = 'RipSubstitute',
        opts = {},
    },

    -- Trouble
    {
        'folke/trouble.nvim',
        cmd = 'Trouble',
        opts = {},
    },

    -- render-markdown
    {
        'MeanderingProgrammer/render-markdown.nvim',
        ft = 'markdown',
        cmd = 'RenderMarkdown',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
    },

    -- formatter
    {
        'stevearc/conform.nvim',
        cmd = 'ConformInfo', -- también carga al formatear con <leader>F
        opts = {
            default_format_opts = { lsp_format = 'fallback' }, -- Lua y demás los formatea el LSP
            formatters_by_ft = {
                python = { 'ruff_organize_imports', 'ruff_format' },
                javascript = { 'prettier' },
                javascriptreact = { 'prettier' },
                typescript = { 'prettier' },
                typescriptreact = { 'prettier' },
                css = { 'prettier' },
                html = { 'prettier' },
                json = { 'prettier' },
                yaml = { 'prettier' },
                markdown = { 'prettier' },
            },
        },
    },

    -- Diagnósticos inline (virtual_text apagado en lsp_config.lua)
    {
        'rachartier/tiny-inline-diagnostic.nvim',
        event = 'VeryLazy',
        priority = 1000,
        opts = {
            hi = { mixing_color = '#1F1F28' }, -- Normal no tiene fondo del que mezclar
        },
    },

    -- Code actions con vista previa (mapeo en lsp_config.lua)
    {
        'rachartier/tiny-code-action.nvim',
        event = 'LspAttach',
        opts = { picker = 'telescope' },
    },

    -- Diffs estilo VS Code (mapeos en which-key)
    {
        'esmuellert/codediff.nvim',
        cmd = 'CodeDiff',
    },

    -- Estela del cursor (antes era un shader de Ghostty)
    {
        'sphamba/smear-cursor.nvim',
        event = 'VeryLazy',
        opts = {
            legacy_computing_symbols_support = true, -- Iosevka los incluye
        },
    },

    -- Animación al copiar y pegar
    {
        'rachartier/tiny-glimmer.nvim',
        event = 'VeryLazy',
        priority = 10, -- después del resto, para respetar sus mapeos
        opts = {
            autoreload = true,
            transparency_color = '#1F1F28',
        },
    },

    -- Scrollbar con diagnósticos y git
    {
        'lewis6991/satellite.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        opts = {
            excluded_filetypes = { 'alpha', 'codediff-explorer', 'codediff-history' },
        },
    },

    -- Estado flotante por ventana
    {
        'b0o/incline.nvim',
        event = 'VeryLazy',
        config = use('incline'),
    },

    -- Sesiones por carpeta
    {
        'olimorris/persisted.nvim',
        event = 'BufReadPre',
        cmd = 'Persisted', -- el botón del dashboard carga antes de abrir un archivo
        config = use('persisted'),
    },

    -- Entornos virtuales de Python
    {
        'linux-cultist/venv-selector.nvim',
        ft = 'python',
        keys = { { '<leader>lv', '<cmd>VenvSelect<cr>', desc = 'Select Venv', ft = 'python' } },
        opts = {},
    },

    -- Hardtime: avisa de malos hábitos sin bloquear
    {
        'm4xshen/hardtime.nvim',
        event = 'VeryLazy',
        dependencies = { 'MunifTanjim/nui.nvim' },
        opts = {
            restriction_mode = 'hint',
            disable_mouse = false, -- satellite y alpha usan el ratón
            resetting_keys = { p = false, P = false }, -- p y P son de tiny-glimmer
            disabled_keys = {
                ['<Up>'] = false,
                ['<Down>'] = false,
                ['<Left>'] = false,
                ['<Right>'] = false,
            },
            disabled_filetypes = { ['codediff.*'] = true, ['fff.*'] = true, dropbar_menu = true },
        },
    },

}, {
    change_detection = { notify = false },
    performance = {
        rtp = { disabled_plugins = { 'gzip', 'tarPlugin', 'tohtml', 'tutor', 'zipPlugin' } },
    },
})
