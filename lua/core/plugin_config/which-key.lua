require("which-key").setup {
    {
        plugins = {
            marks = true,     -- shows a list of your marks on ' and `
            registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
            -- the presets plugin, adds help for a bunch of default keybindings in Neovim
            -- No actual key bindings are created
            spelling = {
                enabled = true,   -- enabling this will show WhichKey when pressing z= to select spelling suggestions
                suggestions = 20, -- how many suggestions should be shown in the list?
            },
            presets = {
                operators = true,    -- adds help for operators like d, y, ...
                motions = true,      -- adds help for motions
                text_objects = true, -- help for text objects triggered after entering an operator
                windows = true,      -- default bindings on <c-w>
                nav = true,          -- misc bindings to work with windows
                z = true,            -- bindings for folds, spelling and others prefixed with z
                g = true,            -- bindings for prefixed with g
            },
        },
        -- add operators that will trigger motion and text object completion
        -- to enable all native operators, set the preset / operators plugin above
        operators = { gc = "Comments" },
        key_labels = {
            -- override the label used to display some keys. It doesn't effect WK in any other way.
            -- For example:
            -- ["<space>"] = "SPC",
            -- ["<cr>"] = "RET",
            -- ["<tab>"] = "TAB",
        },
        motions = {
            count = true,
        },
        icons = {
            breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
            separator = "➜", -- symbol used between a key and it's label
            group = "+", -- symbol prepended to a group
        },
        popup_mappings = {
            scroll_down = "<c-d>", -- binding to scroll down inside the popup
            scroll_up = "<c-u>",   -- binding to scroll up inside the popup
        },
        window = {
            border = "none",          -- none, single, double, shadow
            position = "bottom",      -- bottom, top
            margin = { 1, 0, 1, 0 },  -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
            padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
            winblend = 0,             -- value between 0-100 0 for fully opaque and 100 for fully transparent
            zindex = 1000,            -- positive value to position WhichKey above other floating windows.
        },
        layout = {
            height = { min = 4, max = 25 },                                               -- min and max height of the columns
            width = { min = 20, max = 50 },                                               -- min and max width of the columns
            spacing = 3,                                                                  -- spacing between columns
            align = "left",                                                               -- align columns left, center or right
        },
        ignore_missing = false,                                                           -- enable this to hide mappings for which you didn't specify a label
        hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " }, -- hide mapping boilerplate
        show_help = true,                                                                 -- show a help message in the command line for using WhichKey
        show_keys = true,                                                                 -- show the currently pressed key and its label as a message in the command line
        triggers = "auto",                                                                -- automatically setup triggers
        -- triggers = {"<leader>"} -- or specifiy a list manually
        -- list of triggers, where WhichKey should not wait for timeoutlen and show immediately
        triggers_nowait = {
            -- marks
            "`",
            "'",
            "g`",
            "g'",
            -- registers
            '"',
            "<c-r>",
            -- spelling
            "z=",
        },
        triggers_blacklist = {
            -- list of mode / prefixes that should never be hooked by WhichKey
            -- this is mostly relevant for keymaps that start with a native binding
            i = { "j", "k" },
            v = { "j", "k" },
        },
        -- disable the WhichKey popup for certain buf types and file types.
        -- Disabled by default for Telescope
        disable = {
            buftypes = {},
            filetypes = {},
        },
    }
}

-- Which-Key
local wk = require("which-key")

wk.register({

    ["<leader>m"] = { "<cmd>TSJToggle<CR>", "TreeSJ Toogle" },

    ["<leader>l"] = { '', "Lsp Config" },
    ["<leader>f"] = { name = "Find" },
    ["<leader>x"] = { name = "Trouble" },

    -- MarkDown
    ["mo"] = { '<Plug>MarkdownPreview', 'Open MarkDown' },
    ["mc"] = { "<Plug>MarkdownPreviewStop", "Close MarkDown" },

    -- Exit
    ["<leader>q"] = { "<cmd>qa<cr>", "Exit" },


    -- Cellular Automaton
    ["<leader>c"] = { name = "Cellular Automaton" },
    ["<leader>cm"] = { "<cmd>CellularAutomaton make_it_rain<CR>", "make_it_rain" },
    ["<leader>cg"] = { "<cmd>CellularAutomaton game_of_life<CR>", "game_of_life" },
    ["<leader>cs"] = { "<cmd>CellularAutomaton scramble<CR>", "scramble" },

    --LazyGit
    -- ["<leader>g"] = { name = "Git" },
    -- ["<leader>gg"] = { "<cmd>LazyGit<CR>", "LazyGit" },
    -- ["<leader>gc"] = { "<cmd>LazyGitConfig<CR>", "LazyGitConfig" },
    -- ["<leader>gr"] = { "<cmd>LazyGitCurrentFile<CR>", "LazyGitCurrentFile" },
    -- ["<leader>gf"] = { "<cmd>LazyGitFilter<CR>", "LazyGitFilter" },
    -- ["<leader>gh"] = { "<cmd>LazyGitFilterCurrentFile<CR>", "LazyGitFilterCurrentFile" },

    -- Bufferline
    ["<leader>b"] = { name = "Bufferline" },

    ["<leader>bc"] = { name = "Close" },
    ["<leader>bcl"] = { "<cmd>BufferLineCloseLeft<CR>", "Left" },
    ["<leader>bco"] = { "<cmd>BufferLineCloseOthers<CR>", "Others" },
    ["<leader>bcr"] = { "<cmd>BufferLineCloseRight<CR>", "Right" },

    ["<leader>by"] = { name = "Cycle" },
    ["<leader>byn"] = { "<cmd>BufferLineCycleNext<CR>", "Next" },
    ["<leader>byp"] = { "<cmd>BufferLineCyclePrev<CR>", "Prev" },

    ["<leader>bg"] = { name = "Group" },
    ["<leader>bgc"] = { "<cmd>BufferLineGroupClose<CR>", "Close" },
    ["<leader>bgt"] = { "<cmd>BufferLineGroupToggle<CR>", "Toggle" },


    ["<leader>bm"] = { name = "Move" },
    ["<leader>bmn"] = { "<cmd>BufferLineMoveNext<CR>", "Next" },
    ["<leader>bmp"] = { "<cmd>BufferLineMovePrev<CR>", "Prev" },


    ["<leader>bp"] = { "<cmd>BufferLinePick<CR>", "Pick" },
    ["<leader>bP"] = { "<cmd>BufferLinePickClose<CR>", "Pick Close" },

    ["<leader>bs"] = { name = "SortBy" },
    ["<leader>bsd"] = { "<cmd>BufferLineSortByDirectory<CR>", "Directory" },
    ["<leader>bse"] = { "<cmd>BufferLineSortByExtension<CR>", "Extension" },
    ["<leader>bsr"] = { "<cmd>BufferLineSortByRelativeDirectory<CR>", "RelativeDirectory" },
    ["<leader>bst"] = { "<cmd>BufferLineSortByTabs<CR>", "Tabs" },

    ["<leader>bt"] = { "<cmd>BufferLineTogglePin<CR>", "Toggle Pin" },

    -- Split windows
    ["<leader>w"] = { name = "Window" },
    ["<leader>w|"] = { "<C-W>v", "Horizontal" },
    ["<leader>w-"] = { "<C-W>s", "Vertical" },
    ["<leader>ww"] = { "<C-W>p", "Other window" },
    ["<leader>wd"] = { "<C-W>c", "Delete window" },

    -- Git
    ["<leader>g"] = { name = "Git" },

    -- DAP UI
    ["<leader>d"] = { name = "DAP" },
    ["<leader>dB"] = { function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, "Breakpoint Condition" },
    ["<leader>db"] = { function() require("dap").toggle_breakpoint() end, "Toggle Breakpoint" },
    ["<leader>dc"] = { function() require("dap").continue() end, "Continue" },
    ["<leader>da"] = { function() require("dap").continue({ before = get_args }) end, "Run with Args" },
    ["<leader>dC"] = { function() require("dap").run_to_cursor() end, "Run to Cursor" },
    ["<leader>dg"] = { function() require("dap").goto_() end, "Go to line (no execute)" },
    ["<leader>di"] = { function() require("dap").step_into() end, "Step Into" },
    ["<leader>dj"] = { function() require("dap").down() end, "Down" },
    ["<leader>dk"] = { function() require("dap").up() end, "Up" },
    ["<leader>dl"] = { function() require("dap").run_last() end, "Run Last" },
    ["<leader>do"] = { function() require("dap").step_out() end, "Step Out" },
    ["<leader>dO"] = { function() require("dap").step_over() end, "Step Over" },
    ["<leader>dp"] = { function() require("dap").pause() end, "Pause" },
    ["<leader>dr"] = { function() require("dap").repl.toggle() end, "Toggle REPL" },
    ["<leader>ds"] = { function() require("dap").session() end, "Session" },
    ["<leader>dt"] = { function() require("dap").terminate() end, "Terminate" },
    ["<leader>dw"] = { function() require("dap.ui.widgets").hover() end, "Widgets" },


})

