local wk = require("which-key")

wk.setup({
    preset = "modern",
    win = {
        border = "rounded",
        no_overlap = false,
        -- El preset "modern" recorta a 25 líneas y obliga a hacer scroll.
        height = { min = 4, max = 0.9 },
        width = 0.9,
    },
    layout = {
        width = { min = 20 },
        spacing = 3,
    },
    icons = {
        mappings = true,
        colors = true,
        -- Reglas por patrón: dan icono a mapeos sin icono explícito,
        -- incluidos los buffer-local del LSP (definidos en lsp_config.lua).
        rules = {
            { pattern = "definition",      icon = "",   color = "azure" },
            { pattern = "declaration",     icon = "󱎸",   color = "azure" },
            { pattern = "implementation",  icon = "󱄽",   color = "azure" },
            { pattern = "reference",       icon = "󰈇",   color = "azure" },
            { pattern = "type definition", icon = "󱈤",   color = "azure" },
            { pattern = "rename",          icon = "󰑕",   color = "yellow" },
            { pattern = "code action",     icon = "",   color = "yellow" },
            { pattern = "format",          icon = "󰉼",   color = "cyan" },
            { pattern = "workspace",       icon = "",   color = "purple" },
            { pattern = "breadcrumb",      icon = "󰆤",   color = "blue" },
            { pattern = "context",         icon = "󰆧",   color = "blue" },
            { pattern = "explorer",        icon = "󰙅",   color = "yellow" },
        },
    },
})

wk.add({

    -- ── Acciones básicas ──────────────────────────────────────────────
    { "<leader>s", "<CMD>w<CR>",          desc = "Save",            mode = "n", icon = "󰆓" },
    { "<leader>q", "<CMD>qa<CR>",         desc = "Quit All",        mode = "n", icon = "󰗼" },
    { "<leader>H", "<CMD>nohlsearch<CR>", desc = "Clear Highlight", mode = "n", icon = "󰸱" },
    { "<leader>;", function() require("dropbar.api").pick() end, desc = "Pick Breadcrumb", mode = "n", icon = "󰆤" },

    -- ── Explorador (yazi) ─────────────────────────────────────────────
    { "<leader>e", function() require("yazi").yazi() end,                       desc = "File Explorer",   mode = { "n", "v" }, icon = "󰙅" },
    { "<leader>E", function() require("yazi").yazi(nil, vim.fn.getcwd()) end,   desc = "Explorer (CWD)",  mode = "n",          icon = "󰉋" },
    { "<leader>Y", function() require("yazi").toggle() end,                     desc = "Resume Explorer", mode = "n",          icon = "󰑐" },
    { "-",         function() require("yazi").yazi() end,                       desc = "Open Explorer",   mode = "n",          icon = "󰙅" },

    -- ── Ventanas ──────────────────────────────────────────────────────
    { "<leader>w",  group = "Window", icon = "" },
    { "<leader>w|", "<C-W>v", desc = "Split Vertical",   mode = "n", icon = "" },
    { "<leader>w-", "<C-W>s", desc = "Split Horizontal", mode = "n", icon = "" },
    { "<leader>ww", "<C-W>p", desc = "Other Window",     mode = "n", icon = "󰆾" },
    { "<leader>wo", "<C-W>o", desc = "Close Others",     mode = "n", icon = "󰝤" },
    { "<leader>wd", "<C-W>c", desc = "Delete Window",    mode = "n", icon = "" },

    -- ── Buffers ───────────────────────────────────────────────────────
    { "<leader>b",  group = "Buffers", icon = "󰓩" },
    { "<leader>bn", "<CMD>bnext<CR>",       desc = "Next Buffer",     mode = "n", icon = "" },
    { "<leader>bp", "<CMD>bprevious<CR>",   desc = "Previous Buffer", mode = "n", icon = "" },
    { "<leader>bd", "<CMD>bdelete<CR>",     desc = "Delete Buffer",   mode = "n", icon = "" },
    { "<leader>bl", "<CMD>buffers<CR>",     desc = "List Buffers",    mode = "n", icon = "󰈚" },
    { "<leader>bq", "<CMD>%bd|e#<CR>",      desc = "Delete Others",   mode = "n", icon = "" },

    -- ── LSP (mapeos reales en lsp_config.lua, buffer-local) ───────────
    { "<leader>l", group = "Lsp", icon = "󰛨" },

    -- ── Telescope / Búsqueda ──────────────────────────────────────────
    { "<leader>f",  group = "Find", icon = "" },
    { "<leader>ff", function() require('fff').find_files() end,                           desc = "Find Files",       mode = "n", icon = "󰈞" },
    { "<leader>fF", function() require('telescope.builtin').fd({ cwd = vim.fn.expand('~') }) end,    desc = "Find Files (cwd)", mode = "n", icon = "󰈞" },
    { "<leader>fg", function() require('fff').live_grep() end,                           desc = "Live Grep",        mode = "n", icon = "󰊄" },
    { "<leader>fG", function() require('telescope.builtin').live_grep({ cwd = vim.fn.expand('~') }) end, desc = "Live Grep (cwd)", mode = "n", icon = "󰊄" },
    { "<leader>fh", function() require('telescope.builtin').help_tags() end,             desc = "Help Tags",        mode = "n", icon = "󰮥" },
    { "<leader>fr", function() require('telescope.builtin').oldfiles() end,              desc = "Recent Files",     mode = "n", icon = "" },
    { "<leader>ft", function() require('telescope.builtin').colorscheme({ enable_preview = true, ignore_builtins = true }) end, desc = "Themes", mode = "n", icon = "󰏘" },
    { "<leader>fb", function() require('telescope.builtin').buffers() end,               desc = "Buffers",          mode = "n", icon = "󰓩" },
    { "<leader>fs", function() require("rip-substitute").sub() end,                      desc = "Search & Replace", mode = { "n", "x" }, icon = "" },

    -- ── Modes / Toggles ───────────────────────────────────────────────
    { "<leader>m",  group = "Modes", icon = "" },
    { "<leader>mm", "<CMD>LivePreview start<CR>",                desc = "Markdown Preview", mode = "n", icon = "" },
    { "<leader>mM", "<CMD>LivePreview close<CR>",               desc = "Stop Preview",     mode = "n", icon = "󰅚" },
    { "<leader>mr", "<CMD>RenderMarkdown toggle<CR>",           desc = "Render Markdown",  mode = "n", icon = "" },
    { "<leader>mh", "<CMD>Hardtime toggle<CR>",                 desc = "Hardtime",         mode = "n", icon = "󰥔" },

    -- ── Sesiones ──────────────────────────────────────────────────────
    { "<leader>S",  group = "Sessions", icon = "󰦛" },
    { "<leader>Sl", "<CMD>Persisted load<CR>",   desc = "Load Session",   mode = "n", icon = "󰦛" },
    { "<leader>Ss", "<CMD>Persisted select<CR>", desc = "Select Session", mode = "n", icon = "󰦛" },

    -- ── Trouble ───────────────────────────────────────────────────────
    { "<leader>x",  group = "Trouble", icon = "" },
    { "<leader>xx", "<CMD>Trouble diagnostics toggle<CR>",                       desc = "Diagnostics",        mode = "n", icon = "" },
    { "<leader>xX", "<CMD>Trouble diagnostics toggle filter.buf=0<CR>",          desc = "Buffer Diagnostics", mode = "n", icon = "" },
    { "<leader>xs", "<CMD>Trouble symbols toggle focus=false<CR>",               desc = "Symbols",            mode = "n", icon = "󱔁" },
    { "<leader>xl", "<CMD>Trouble lsp toggle focus=false win.position=right<CR>", desc = "LSP References",    mode = "n", icon = "" },
    { "<leader>xt", "<CMD>Trouble todo toggle<CR>",                              desc = "Todo",               mode = "n", icon = "" },
    { "<leader>xL", "<CMD>Trouble loclist toggle<CR>",                           desc = "Location List",      mode = "n", icon = "" },
    { "<leader>xQ", "<CMD>Trouble qflist toggle<CR>",                            desc = "Quickfix List",      mode = "n", icon = "" },

    -- ── Git (gitsigns) ────────────────────────────────────────────────
    { "<leader>h", group = "Git", icon = "" },

    -- Hunks
    { "<leader>hh",  group = "Hunks", mode = { "n", "v" }, icon = "" },
    { "<leader>hhs", function() require('gitsigns').stage_hunk() end, desc = "Stage Hunk", mode = "n", icon = "" },
    { "<leader>hhr", function() require('gitsigns').reset_hunk() end, desc = "Reset Hunk", mode = "n", icon = "" },
    { "<leader>hhs", function() require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, desc = "Stage Hunk (visual)", mode = "v", icon = "" },
    { "<leader>hhr", function() require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, desc = "Reset Hunk (visual)", mode = "v", icon = "" },
    { "<leader>hhS", function() require('gitsigns').stage_buffer() end,          desc = "Stage Buffer",        mode = "n", icon = "" },
    { "<leader>hhR", function() require('gitsigns').reset_buffer() end,          desc = "Reset Buffer",        mode = "n", icon = "" },
    { "<leader>hhp", function() require('gitsigns').preview_hunk() end,          desc = "Preview Hunk",        mode = "n", icon = "" },
    { "<leader>hhi", function() require('gitsigns').preview_hunk_inline() end,   desc = "Preview Hunk Inline", mode = "n", icon = "" },
    { "<leader>hhb", function() require('gitsigns').blame_line({ full = true }) end, desc = "Blame Line",      mode = "n", icon = "" },

    -- Diff
    { "<leader>hd",  group = "Diff", mode = "n", icon = "" },
    { "<leader>hdh", function() require('gitsigns').diffthis() end,    desc = "Diff This",     mode = "n", icon = "" },
    { "<leader>hdH", function() require('gitsigns').diffthis('~') end, desc = "Diff This (~)", mode = "n", icon = "" },

    { "<leader>hdd", "<CMD>CodeDiff<CR>",         desc = "Code Diff",    mode = "n", icon = "󰦓" },
    { "<leader>hdf", "<CMD>CodeDiff history<CR>", desc = "Diff History", mode = "n", icon = "󰋚" },

    -- Quickfix
    { "<leader>hq",  group = "Quickfix", mode = "n", icon = "" },
    { "<leader>hqa", function() require('gitsigns').setqflist('all') end, desc = "All Hunks to Quickfix", mode = "n", icon = "" },
    { "<leader>hqh", function() require('gitsigns').setqflist() end,      desc = "Hunks to Quickfix",     mode = "n", icon = "" },

    -- Toggles
    { "<leader>ht",  group = "Toggle", icon = "" },
    { "<leader>htb", function() require('gitsigns').toggle_current_line_blame() end, desc = "Toggle Blame Line", mode = "n", icon = "" },
    { "<leader>htw", function() require('gitsigns').toggle_word_diff() end,          desc = "Toggle Word Diff",  mode = "n", icon = "" },

    -- Navegación de hunks
    {
        "]c",
        function()
            if vim.wo.diff then vim.cmd.normal({ ']c', bang = true })
            else require('gitsigns').nav_hunk('next') end
        end,
        desc = "Next Hunk", mode = "n", icon = "",
    },
    {
        "[c",
        function()
            if vim.wo.diff then vim.cmd.normal({ '[c', bang = true })
            else require('gitsigns').nav_hunk('prev') end
        end,
        desc = "Previous Hunk", mode = "n", icon = "",
    },

    -- Navegación de breadcrumbs (dropbar)
    {
        "[;",
        function() require("dropbar.api").goto_context_start() end,
        desc = "Context Start", mode = "n", icon = "󰆧",
    },
    {
        "];",
        function() require("dropbar.api").select_next_context() end,
        desc = "Next Context", mode = "n", icon = "󰆧",
    },

    -- Text object
    { "ih", ":<C-U>Gitsigns select_hunk<CR>", desc = "Select Hunk", mode = { "o", "x" }, icon = "" },

})
