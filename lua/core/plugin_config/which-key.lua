local wk = require("which-key")

wk.add({

    -- Exit
    { "<leader>q", "<CMD>qa<CR>", name = "Exit", mode = "n" },
    { "<leader>s", "<CMD>w<CR>", name = "Save", mode = "n", icon = "󰆓" },

    -- Split windows
    { "<leader>w", group = "Window" },
    { "<leader>w|", "<C-W>v", desc = "Horizontal", mode = "n", icon = "" },
    { "<leader>w-", "<C-W>s", desc = "Vertical", mode = "n", icon = "" },
    { "<leader>ww", "<C-W>p", desc = "Other window", mode = "n", icon = "󰆾" },
    { "<leader>wd", "<C-W>c", desc = "Delete window", mode = "n", icon = "" },

    -- Git
    { "<leader>g", group = "Git" },

    -- DAP UI
    { "<leader>d", group = "DAP" },
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition", mode = "n" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint", mode = "n" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue", mode = "n" },
    { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args", mode = "n" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor", mode = "n" },
    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)", mode = "n" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into", mode = "n" },
    { "<leader>dj", function() require("dap").down() end, desc = "Down", mode = "n" },
    { "<leader>dk", function() require("dap").up() end, desc = "Up", mode = "n" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last", mode = "n" },
    { "<leader>do", function() require("dap").step_out() end, desc = "Step Out", mode = "n" },
    { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over", mode = "n" },
    { "<leader>dp", function() require("dap").pause() end, desc = "Pause", mode = "n" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL", mode = "n" },
    { "<leader>ds", function() require("dap").session() end, desc = "Session", mode = "n" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate", mode = "n" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets", mode = "n" },


    -- Create all commands to buffers
    { "<leader>b", group = "Buffers" },
    { "<leader>bq", "<CMD>%bd|e#<CR>", desc = "Delete all buffers except current", mode = "n" },
    { "<leader>bl", "<CMD>buffers<CR>", desc = "List all buffers", mode = "n" },


    -- Lsp
    { "<leader>l", group = "Lsp", icon = "󰛨" },

    -- Avante
    { "<leader>a", group = "Avante", icon = "󱚝" },

    -- NOTE: -- Modes --
    { "<leader>m", group = "Modes", icon = "" },

    -- Twilight mode
    { "<leader>mt", function() require("twilight").toggle() end, desc = "Twilight", mode = "n", icon = "󰨀" },

    -- Rip substitute
    { "<leader>fs", function() require("rip-substitute").sub() end, desc = "Twilight", mode = { "n", "x" }, icon = "" },

    -- Markdown Preview
    { "<leader>r", group = "Render Markdokn" },
    { "<leader>mm", "<CMD>MarkdownPreviewToggle<CR>", desc = "Markdown", mode = "n", icon = "" },

    -- Goto
    { "<leader>g", group = "Goto", icon = "󱥼" },
    { "<leader>gd", function() require('goto-preview').goto_preview_definition() end, desc = "Definition", mode = "n", icon = "" },
    { "<leader>gt", function() require('goto-preview').goto_preview_type_definition() end, desc = "Type Definition", mode = "n", icon = "󱈤" },
    { "<leader>gi", function() require('goto-preview').goto_preview_implementation() end, desc = "Implementation", mode = "n", icon = "󱄽" },
    { "<leader>gd", function() require('goto-preview').goto_preview_declaration() end, desc = "Declaration", mode = "n", icon = "󱎸" },
    { "<leader>gP", function() require('goto-preview').close_all_win() end, desc = "Close All Windows", mode = "n", icon = "󱄊" },
    { "<leader>gr", function() require('goto-preview').goto_preview_references() end, desc = "Goto References", mode = "n", icon = "󰔯" },


    -- Telescope
    { "<leader>f", group = "Telescope" },
    { "<leader>ff", function() require('telescope.builtin').fd() end, desc = "Find Files", mode = "n", icon = "󰈞" },
    { "<leader>fF", function() require('telescope.builtin').fd({ cwd = '$HOME' }) end, desc = "Find Files (cwd)", mode = "n" },
    { "<leader>fg", function() require('telescope.builtin').live_grep() end, desc = "Live Grep", mode = "n" },
    { "<leader>fG", function() require('telescope.builtin').live_grep({ cwd = '$HOME' }) end, desc = "Live Grep (cwd)", mode = "n" },
    { "<leader>fh", function() require('telescope.builtin').help_tags() end, desc = "Help Tags", mode = "n", icon = "󰮥" },
    { "<leader>fr", function() require('telescope.builtin').oldfiles() end, desc = "Recently Opened Files", mode = "n", icon = "" },
    { "<leader>fb", function() require('telescope.builtin').buffers() end, desc = "Buffers", mode = "n" },
    { "<leader>fp", "<CMD>Telescope harpoon marks<CR>", desc = "Harpoon", mode = "n" },

    -- Harpoon
    { "<leader>p", group = "Harpoon", icon = "" },
    { "<leader>pa", function() require('harpoon.mark').add_file() end, desc = "Add File", mode = "n" },
    { "<leader>pm", function() require('harpoon.ui').toggle_quick_menu() end, desc = "Quick Menu", mode = "n" },
    { "<leader>pn", function() require('harpoon.ui').nav_next() end, desc = "Next Mark", mode = "n", icon = "" },
    { "<leader>pp", function() require('harpoon.ui').nav_prev() end, desc = "Prev Mark", mode = "n", icon = "" },


    -- Trouble
    { "<leader>x", group = "Trouble", mode = "n", icon = "" },
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics", mode = "n" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics", mode = "n" },
    { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols", mode = "n", icon = "󱔁" },
    { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ...", mode = "n", icon = "" },
    { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List", mode = "n", icon = "" },
    { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List", mode = "n" },

    -- NOTE: -- Gitsign --
    { "<leader>h", group = "Git" },
    -- Hunks
    { "<leader>hh", group = "Hunks", mode = { "n", "v" } },
    { "<leader>hhs", function() require('gitsigns').stage_hunk() end, desc = "Stage hunk", mode = "n" },
    { "<leader>hhr", function() require('gitsigns').reset_hunk() end, desc = "Reset hunk", mode = "n" },
    { "<leader>hhs", function() require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, desc = "Stage hunk (visual)", mode = "v" },
    { "<leader>hhr", function() require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, desc = "Reset hunk (visual)", mode = "v" },
    { "<leader>hhS", function() require('gitsigns').stage_buffer() end, desc = "Stage buffer", mode = "n" },
    { "<leader>hhR", function() require('gitsigns').reset_buffer() end, desc = "Reset buffer", mode = "n" },
    { "<leader>hhp", function() require('gitsigns').preview_hunk() end, desc = "Preview hunk", mode = "n" },
    { "<leader>hhi", function() require('gitsigns').preview_hunk_inline() end, desc = "Preview hunk inline", mode = "n" },
    { "<leader>hhb", function() require('gitsigns').blame_line({ full = true }) end, desc = "Blame line", mode = "n" },

    -- Diff
    { "<leader>hd", group = "Diff", mode = "n" },
    { "<leader>hdh", function() require('gitsigns').diffthis() end, desc = "Diff this", mode = "n" },
    { "<leader>hdH", function() require('gitsigns').diffthis('~') end, desc = "Diff this (~)", mode = "n" },

    -- Quickfix
    { "<leader>hq", group = "Quickfix", mode = "n" },
    { "<leader>hqa", function() require('gitsigns').setqflist('all') end, desc = "All hunks to quickfix", mode = "n" },
    { "<leader>hqh", function() require('gitsigns').setqflist() end, desc = "Hunks to quickfix", mode = "n" },

    -- Toggles
    { "<leader>ht", group = "Toggle" },
    { "<leader>htb", function() require('gitsigns').toggle_current_line_blame() end, desc = "Toggle blame line", mode = "n" },
    { "<leader>htw", function() require('gitsigns').toggle_word_diff() end, desc = "Toggle word diff", mode = "n" },

    -- Navegación
    {
        "]c",
        function()
            if vim.wo.diff then
                vim.cmd.normal({ ']c', bang = true })
            else
                require('gitsigns').nav_hunk('next')
            end
        end,
        desc = "Next hunk",
        mode = "n"
    },
    {
        "[c",
        function()
            if vim.wo.diff then
                vim.cmd.normal({ '[c', bang = true })
            else
                require('gitsigns').nav_hunk('prev')
            end
        end,
        desc = "Previous hunk",
        mode = "n"
    },

    -- Text object
    { "ih", ":<C-U>Gitsigns select_hunk<CR>", desc = "Select hunk", mode = { "o", "x" } },



})
