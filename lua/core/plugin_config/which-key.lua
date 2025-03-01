   local wk = require("which-key")
wk.add({

    -- Exit
    { "<leader>q",  "<CMD>qa<CR>", desc = "Exit", mode = "n" },
    { "<leader>s",  "<CMD>w<CR>", desc = "Save", mode = "n" },

    -- Bufferline
    -- { "<leader>b", group = "Bufferline" },
    -- { "<leader>bc", group = "Close" },
    -- { "<leader>bcl", "<cmd>BufferLineCloseLeft<CR>", desc = "Left", mode = "n" },
    -- { "<leader>bco", "<cmd>BufferLineCloseOthers<CR>", desc = "Others", mode = "n" },
    -- { "<leader>bcr", "<cmd>BufferLineCloseRight<CR>", desc = "Right", mode = "n" },
    -- { "<leader>by", group = "Cycle" },
    -- { "<leader>byn", "<cmd>BufferLineCycleNext<CR>", desc = "Next", mode = "n" },
    -- { "<leader>byp", "<cmd>BufferLineCyclePrev<CR>", desc = "Prev", mode = "n" },
    -- { "<leader>bg", group = "Group" },
    -- { "<leader>bgc", "<cmd>BufferLineGroupClose<CR>", desc = "Close", mode = "n" },
    -- { "<leader>bgt", "<cmd>BufferLineGroupToggle<CR>", desc = "Toggle", mode = "n" },
    -- { "<leader>bm", group = "Move" },
    -- { "<leader>bmn", "<cmd>BufferLineMoveNext<CR>", desc = "Next", mode = "n" },
    -- { "<leader>bmp", "<cmd>BufferLineMovePrev<CR>", desc = "Prev", mode = "n" },
    -- { "<leader>bp", "<cmd>BufferLinePick<CR>", desc = "Pick", mode = "n" },
    -- { "<leader>bP", "<cmd>BufferLinePickClose<CR>", desc = "Pick Close", mode = "n" },
    -- { "<leader>bs", group = "SortBy" },
    -- { "<leader>bsd", "<cmd>BufferLineSortByDirectory<CR>", desc = "Directory", mode = "n" },
    -- { "<leader>bse", "<cmd>BufferLineSortByExtension<CR>", desc = "Extension", mode = "n" },
    -- { "<leader>bsr", "<cmd>BufferLineSortByRelativeDirectory<CR>", desc = "RelativeDirectory", mode = "n" },
    -- { "<leader>bst", "<cmd>BufferLineSortByTabs<CR>", desc = "Tabs", mode = "n" },
    -- { "<leader>bt", "<cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin", mode = "n" },

    -- Split windows
    { "<leader>w",  group = "Window" }, 
    { "<leader>w|", "<C-W>v",desc = "Horizontal", mode = "n" },
    { "<leader>w-", "<C-W>s", desc = "Vertical", mode = "n" },
    { "<leader>ww", "<C-W>p", desc = "Other window", mode = "n" },
    { "<leader>wd", "<C-W>c", desc = "Delete window", mode = "n" },

    -- Git
    { "<leader>g",  group = "Git" },

    -- DAP UI
    { "<leader>d",  group = "DAP" },
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
    { "<leader>dt", function() require("dap").terminate() end,                                            desc = "Terminate", mode = "n" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets", mode = "n" },

    -- Lsp Config
    { "<leader>l",  desc = "Lsp Config", mode = "n" },

    -- Into
    { "<leader>wd", "<C-W>c", desc = "Delete window", mode = "n" },

    { "<leader>f",  group = "Telescope" },

    -- Delete all buffers except current

    -- Create all commands to buffers
    { "<leader>b",  group = "Buffers" },
    { "<leader>bq", "<CMD>%bd|e#<CR>", desc = "Delete all buffers except current", mode = "n" },
    { "<leader>bl", "<CMD>buffers<CR>", desc = "List all buffers", mode = "n" },
        

    -- Modes
    { "<leader>m",  group = "Modes" },
    
    -- Twilight mode 
    { "<leader>mt", function() require("twilight").toggle() end, desc = "Twilight", mode = "n" },

    -- Render Markdown
    { "<leader>r",  group = "Render Markdown" },
    { "<leader>rt", function() require("render-markdown").toggle() end, desc = "Toggle", mode = "n" },
    { "<leader>rb",  group = "Buffers" },
    { "<leader>rbd", function() require("render-markdown").buf_disable() end, desc = "Buffer Disable", mode = "n" },
    { "<leader>rbe", function() require("render-markdown").buf_enable() end, desc = "Buffer Enable", mode = "n" },
    { "<leader>rbt", function() require("render-markdown").buf_toggle() end, desc = "Buffer Toggle", mode = "n" },
    { "<leader>rc", function() require("render-markdown").config() end, desc = "Default Config", mode = "n" },
    { "<leader>ro", function() require("render-markdown").contract() end, desc = "Contract", mode = "n" },
    { "<leader>rd", function() require("render-markdown").debug() end, desc = "Debug", mode = "n" },
    { "<leader>re", function() require("render-markdown").enable() end, desc = "Enable", mode = "n" },
    { "<leader>ri", function() require("render-markdown").disable() end, desc = "Disable", mode = "n" },
    { "<leader>rl", function() require("render-markdown").log() end, desc = "Log", mode = "n" },
    { "<leader>rx", function() require("render-markdown").expand() end, desc = "Expand", mode = "n" },
    

    -- Goto
   { "<leader>g",  group = "Goto" },
   { "<leader>gd", function() require('goto-preview').goto_preview_definition() end, desc = "Goto Definition", mode = "n" },
   { "<leader>gt", function() require('goto-preview').goto_preview_type_definition() end, desc = "Goto Type Definition", mode = "n" },
   { "<leader>gi", function() require('goto-preview').goto_preview_implementation() end, desc = "Goto Implementation", mode = "n" },
   { "<leader>gd", function() require('goto-preview').goto_preview_declaration() end, desc = "Goto Declaration", mode = "n" },
   { "<leader>gP", function() require('goto-preview').close_all_win() end, desc = "Close All Windows", mode = "n" },
   { "<leader>gr", function() require('goto-preview').goto_preview_references() end, desc = "Goto References", mode = "n" },

})
