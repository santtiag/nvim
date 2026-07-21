local wk = require("which-key")

wk.setup({
    preset = "modern",
    win = { border = "rounded" },
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
        },
    },
})

wk.add({

    -- ── Acciones básicas ──────────────────────────────────────────────
    { "<leader>s", "<CMD>w<CR>",          desc = "Save",             mode = "n", icon = "󰆓" },
    { "<leader>q", "<CMD>qa<CR>",         desc = "Quit All",         mode = "n", icon = "󰗼" },
    { "<leader>e", "<CMD>Oil<CR>",        desc = "File Explorer",    mode = "n", icon = "󰙅" },
    { "<leader>H", "<CMD>nohlsearch<CR>", desc = "Clear Highlight",  mode = "n", icon = "󰸱" },

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
    { "<leader>ff", function() require('telescope.builtin').fd() end,                     desc = "Find Files",       mode = "n", icon = "󰈞" },
    { "<leader>fF", function() require('telescope.builtin').fd({ cwd = '$HOME' }) end,    desc = "Find Files (cwd)", mode = "n", icon = "󰈞" },
    { "<leader>fg", function() require('telescope.builtin').live_grep() end,             desc = "Live Grep",        mode = "n", icon = "󰊄" },
    { "<leader>fG", function() require('telescope.builtin').live_grep({ cwd = '$HOME' }) end, desc = "Live Grep (cwd)", mode = "n", icon = "󰊄" },
    { "<leader>fh", function() require('telescope.builtin').help_tags() end,             desc = "Help Tags",        mode = "n", icon = "󰮥" },
    { "<leader>fr", function() require('telescope.builtin').oldfiles() end,              desc = "Recent Files",     mode = "n", icon = "" },
    { "<leader>fb", function() require('telescope.builtin').buffers() end,               desc = "Buffers",          mode = "n", icon = "󰓩" },
    { "<leader>fp", "<CMD>Telescope harpoon marks<CR>",                                  desc = "Harpoon Marks",    mode = "n", icon = "󱡁" },
    { "<leader>fs", function() require("rip-substitute").sub() end,                      desc = "Search & Replace", mode = { "n", "x" }, icon = "" },

    -- ── Goto (goto-preview) ───────────────────────────────────────────
    { "<leader>g",  group = "Goto", icon = "󱥼" },
    { "<leader>gd", function() require('goto-preview').goto_preview_definition() end,       desc = "Definition",      mode = "n", icon = "" },
    { "<leader>gD", function() require('goto-preview').goto_preview_declaration() end,      desc = "Declaration",     mode = "n", icon = "󱎸" },
    { "<leader>gt", function() require('goto-preview').goto_preview_type_definition() end,  desc = "Type Definition", mode = "n", icon = "󱈤" },
    { "<leader>gi", function() require('goto-preview').goto_preview_implementation() end,   desc = "Implementation",  mode = "n", icon = "󱄽" },
    { "<leader>gr", function() require('goto-preview').goto_preview_references() end,       desc = "References",      mode = "n", icon = "󰈇" },
    { "<leader>gP", function() require('goto-preview').close_all_win() end,                 desc = "Close All Windows", mode = "n", icon = "󱄊" },

    -- ── Modes / Toggles ───────────────────────────────────────────────
    { "<leader>m",  group = "Modes", icon = "" },
    { "<leader>mm", "<CMD>MarkdownPreviewToggle<CR>",           desc = "Markdown Preview", mode = "n", icon = "" },
    { "<leader>mr", "<CMD>RenderMarkdown toggle<CR>",           desc = "Render Markdown",  mode = "n", icon = "" },
    { "<leader>mt", function() require("twilight").toggle() end, desc = "Twilight",        mode = "n", icon = "󰨀" },

    -- ── Harpoon ───────────────────────────────────────────────────────
    { "<leader>p",  group = "Harpoon", icon = "" },
    { "<leader>pa", function() require('harpoon.mark').add_file() end,        desc = "Add File",   mode = "n", icon = "󰐕" },
    { "<leader>pm", function() require('harpoon.ui').toggle_quick_menu() end, desc = "Quick Menu", mode = "n", icon = "" },
    { "<leader>pn", function() require('harpoon.ui').nav_next() end,          desc = "Next Mark",  mode = "n", icon = "" },
    { "<leader>pp", function() require('harpoon.ui').nav_prev() end,          desc = "Prev Mark",  mode = "n", icon = "" },

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

    -- Text object
    { "ih", ":<C-U>Gitsigns select_hunk<CR>", desc = "Select Hunk", mode = { "o", "x" }, icon = "" },

})
