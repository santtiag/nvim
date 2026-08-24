local conditions = require('heirline.conditions')
local utils = require('heirline.utils')

local function hex(group, key, fallback)
    local hl = utils.get_highlight(group)
    local value = hl and hl[key]
    if type(value) == 'number' then
        return string.format('#%06x', value)
    end
    return value or fallback
end

local function setup_colors()
    local palette = {}
    local ok, kanagawa = pcall(require, 'kanagawa.colors')
    if ok then
        palette = kanagawa.setup().palette or {}
    end

    return {
        ink = palette.sumiInk0 or hex('Normal', 'bg', '#1F1F28') or '#1F1F28',
        ink4 = palette.sumiInk4 or '#2A2A37',
        fuji = palette.fujiWhite or hex('Normal', 'fg', '#DCD7BA'),
        muted = palette.fujiGray or hex('Comment', 'fg', '#727169'),
        crystal = palette.crystalBlue or hex('Function', 'fg', '#7E9CD8'),
        spring = palette.springGreen or hex('String', 'fg', '#98BB6C'),
        oni = palette.oniViolet or hex('Statement', 'fg', '#957FB8'),
        carp = palette.carpYellow or hex('Constant', 'fg', '#E6C384'),
        peach = palette.peachRed or hex('DiagnosticError', 'fg', '#E82424'),
        wave = palette.waveAqua2 or hex('Special', 'fg', '#7AA89F'),
        sakura = palette.sakuraPink or hex('Identifier', 'fg', '#D27E99'),
        surimi = palette.surimiOrange or hex('Constant', 'fg', '#FFA066'),
        samurai = palette.samuraiRed or hex('Error', 'fg', '#C34043'),
        diag_error = hex('DiagnosticError', 'fg', '#E82424'),
        diag_warn = hex('DiagnosticWarn', 'fg', '#FF9E3B'),
        diag_info = hex('DiagnosticInfo', 'fg', '#6A9589'),
        diag_hint = hex('DiagnosticHint', 'fg', '#658594'),
        git_add = hex('GitSignsAdd', 'fg', palette.autumnGreen or '#76946A'),
        git_change = hex('GitSignsChange', 'fg', palette.autumnYellow or '#DCA561'),
        git_del = hex('GitSignsDelete', 'fg', palette.autumnRed or '#C34043'),
        none = 'NONE',
    }
end

local git_arrows = ''

local function update_git_arrows()
    vim.system(
        { 'git', 'rev-list', '--left-right', '--count', 'HEAD...@{upstream}' },
        { text = true },
        function(out)
            local result = ''
            if out.code == 0 and out.stdout then
                local ahead, behind = out.stdout:match('(%d+)%s+(%d+)')
                if ahead and behind then
                    local parts = {}
                    if ahead ~= '0' then table.insert(parts, '↑' .. ahead) end
                    if behind ~= '0' then table.insert(parts, '↓' .. behind) end
                    result = table.concat(parts, ' ')
                end
            end
            vim.schedule(function()
                if git_arrows == result then return end
                git_arrows = result
                vim.cmd.redrawstatus()
            end)
        end
    )
end

local augroup = vim.api.nvim_create_augroup('user.heirline', { clear = true })
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufWritePost', 'DirChanged', 'VimEnter' }, {
    group = augroup,
    callback = update_git_arrows,
})
update_git_arrows()

local Align = { provider = '%=' }
local Space = { provider = ' ' }

local ViMode = {
    init = function(self)
        self.mode = vim.fn.mode(1)
    end,
    static = {
        mode_names = {
            n = '常 NORMAL',
            no = '常 NORMAL',
            nov = '常 NORMAL',
            noV = '常 NORMAL',
            ['no\22'] = '常 NORMAL',
            niI = '常 NORMAL',
            niR = '常 NORMAL',
            niV = '常 NORMAL',
            nt = '常 NORMAL',
            v = '視 VISUAL',
            vs = '視 VISUAL',
            V = '視 V-LINE',
            Vs = '視 V-LINE',
            ['\22'] = '視 V-BLOCK',
            ['\22s'] = '視 V-BLOCK',
            s = '選 SELECT',
            S = '選 S-LINE',
            ['\19'] = '選 S-BLOCK',
            i = '入 INSERT',
            ic = '入 INSERT',
            ix = '入 INSERT',
            R = '換 REPLACE',
            Rc = '換 REPLACE',
            Rx = '換 REPLACE',
            Rv = '換 V-REPLACE',
            Rvc = '換 V-REPLACE',
            Rvx = '換 V-REPLACE',
            c = '令 COMMAND',
            cv = '令 EX',
            r = '…',
            rm = '令 MORE',
            ['r?'] = '令 CONFIRM',
            ['!'] = '端 SHELL',
            t = '端 TERMINAL',
        },
    },
    provider = function(self)
        return ' ' .. (self.mode_names[self.mode] or self.mode) .. ' '
    end,
    hl = { fg = 'ink', bold = true },
    update = {
        'ModeChanged',
        pattern = '*:*',
        callback = vim.schedule_wrap(function()
            vim.cmd.redrawstatus()
        end),
    },
}

local ModeBlock = utils.surround({ '', '' }, function(self)
    return self:mode_color()
end, ViMode)

local GitBranch = {
    init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict or {}
    end,
    {
        provider = function(self)
            local head = self.status_dict.head
            if not head or head == '' then return end
            return ' 󰘬 ' .. head
        end,
        hl = { fg = 'carp', bold = true },
    },
    {
        condition = function()
            return git_arrows ~= ''
        end,
        provider = function()
            return ' ' .. git_arrows
        end,
        hl = { fg = 'wave' },
    },
    { provider = ' ' },
}

local GitBlock = utils.surround({ '', '' }, 'ink4', GitBranch)
GitBlock.condition = conditions.is_git_repo

local GitDiff = {
    init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
    end,
    {
        provider = function(self)
            local count = self.status_dict.added or 0
            return count > 0 and ('+' .. count .. ' ')
        end,
        hl = { fg = 'git_add' },
    },
    {
        provider = function(self)
            local count = self.status_dict.changed or 0
            return count > 0 and ('~' .. count .. ' ')
        end,
        hl = { fg = 'git_change' },
    },
    {
        provider = function(self)
            local count = self.status_dict.removed or 0
            return count > 0 and ('-' .. count .. ' ')
        end,
        hl = { fg = 'git_del' },
    },
}

local DiffBlock = utils.surround({ '', '' }, 'ink4', {
    { provider = ' ' },
    GitDiff,
})
DiffBlock.condition = function()
    local d = vim.b.gitsigns_status_dict
    return d and ((d.added or 0) > 0 or (d.changed or 0) > 0 or (d.removed or 0) > 0)
end

local FileIcon = {
    init = function(self)
        local filename = self.filename
        local extension = vim.fn.fnamemodify(filename, ':e')
        self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
    end,
    provider = function(self)
        return self.icon and (self.icon .. ' ')
    end,
    hl = function(self)
        return { fg = self.icon_color }
    end,
}

local FileName = {
    provider = function(self)
        local filename = vim.fn.fnamemodify(self.filename, ':.')
        if filename == '' then return '[No Name]' end
        if not conditions.width_percent_below(#filename, 0.35) then
            filename = vim.fn.pathshorten(filename)
        end
        return filename
    end,
    hl = { fg = 'sakura', bold = true },
}

local FileFlags = {
    {
        condition = function()
            return vim.bo.modified
        end,
        provider = ' ●',
        hl = { fg = 'spring' },
    },
    {
        condition = function()
            return not vim.bo.modifiable or vim.bo.readonly
        end,
        provider = ' ',
        hl = { fg = 'carp' },
    },
}

local FileNameBlock = {
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
    end,
    FileIcon,
    FileName,
    FileFlags,
}

local Hanko = utils.surround({ '', '' }, 'ink4', {
    { provider = ' ' },
    FileNameBlock,
    { provider = ' ' },
})
Hanko.condition = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
end

local MacroRec = {
    provider = function()
        return ' 󰑋 @' .. vim.fn.reg_recording() .. ' '
    end,
    hl = { fg = 'ink', bold = true },
    update = { 'RecordingEnter', 'RecordingLeave' },
}

local MacroBlock = utils.surround({ '', '' }, 'peach', MacroRec)
MacroBlock.condition = function()
    return vim.fn.reg_recording() ~= ''
end

local SearchCount = {
    condition = function()
        return vim.v.hlsearch ~= 0
    end,
    init = function(self)
        local ok, search = pcall(vim.fn.searchcount)
        if ok and search.total then
            self.search = search
        end
    end,
    provider = function(self)
        local search = self.search
        if not search or search.total == 0 then return end
        return string.format(' %d/%d', search.current, math.min(search.total, search.maxcount))
    end,
    hl = { fg = 'carp' },
}

local SelectionCount = {
    condition = function()
        return vim.fn.mode():find('[vV\22]') ~= nil
    end,
    provider = function()
        local starts = vim.fn.line('v')
        local ends = vim.fn.line('.')
        local lines = math.abs(ends - starts) + 1
        return '󰒉 ' .. lines
    end,
    hl = { fg = 'oni' },
}

local lsp_icons = {
    lua_ls = ' ',
    pyright = ' ',
    basedpyright = ' ',
    ts_ls = ' ',
    rust_analyzer = ' ',
    gopls = ' ',
    clangd = ' ',
    bashls = ' ',
    jsonls = ' ',
    html = ' ',
    cssls = ' ',
    lazydev = '💤 ',
}

local LSPActive = {
    update = { 'LspAttach', 'LspDetach', 'BufEnter' },
    flexible = 4,
    {
        provider = function()
            local names = {}
            for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
                table.insert(names, (lsp_icons[client.name] or '󰒋 ') .. client.name)
            end
            return ' ' .. table.concat(names, ' ') .. ' '
        end,
        hl = { fg = 'fuji', bold = true },
    },
    {
        provider = ' 󰒋 ',
        hl = { fg = 'fuji', bold = true },
    },
}

local LSPBlock = utils.surround({ '', '' }, 'ink4', LSPActive)
LSPBlock.condition = conditions.lsp_attached

local Diagnostics = {
    init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    end,
    update = { 'DiagnosticChanged', 'BufEnter' },
    {
        provider = function(self)
            return self.errors > 0 and (' ' .. self.errors .. ' ')
        end,
        hl = { fg = 'diag_error' },
    },
    {
        provider = function(self)
            return self.warnings > 0 and (' ' .. self.warnings .. ' ')
        end,
        hl = { fg = 'diag_warn' },
    },
    {
        provider = function(self)
            return self.info > 0 and (' ' .. self.info .. ' ')
        end,
        hl = { fg = 'diag_info' },
    },
    {
        provider = function(self)
            return self.hints > 0 and ('󰌵 ' .. self.hints .. ' ')
        end,
        hl = { fg = 'diag_hint' },
    },
}

local DiagnosticsBlock = utils.surround({ '', '' }, 'ink4', {
    { provider = ' ' },
    Diagnostics,
})
DiagnosticsBlock.condition = conditions.has_diagnostics

local LazyUpdates = {
    condition = function()
        local ok, lazy = pcall(require, 'lazy.status')
        return ok and lazy.has_updates()
    end,
    provider = function()
        return ' ' .. require('lazy.status').updates() .. ' '
    end,
    hl = { fg = 'surimi', bold = true },
}

local FileType = {
    provider = function()
        local ft = vim.bo.filetype
        if ft == '' then return end
        return ' ' .. ft .. ' '
    end,
    hl = { fg = 'muted' },
}

local Harpoon = {
    condition = function()
        local mark = package.loaded['harpoon.mark']
        if not mark then return false end
        local total = mark.get_length()
        return total and total > 0
    end,
    provider = function()
        local mark = package.loaded['harpoon.mark']
        local total = mark.get_length()
        local idx = mark.get_current_index()
        return string.format(' 󰛢 %s/%d ', idx or '·', total)
    end,
    hl = { fg = 'wave' },
}

local HarpoonBlock = utils.surround({ '', '' }, 'ink4', Harpoon)
HarpoonBlock.condition = Harpoon.condition

local Ruler = {
    provider = ' %l:%c  %P ',
    hl = { fg = 'ink', bold = true },
}

local Clock = {
    flexible = 3,
    {
        provider = function()
            return '時 ' .. os.date('%H:%M') .. ' '
        end,
    },
    { provider = '' },
    hl = { fg = 'ink', bold = true },
}

local MetaBlock = utils.surround({ '', '' }, function(self)
    return self:mode_color()
end, {
    Ruler,
    Clock,
})

local FileEncoding = {
    flexible = 1,
    {
        provider = function()
            local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc
            if enc == '' or enc == 'utf-8' then return end
            return enc:upper() .. ' '
        end,
        hl = { fg = 'muted' },
    },
    { provider = '' },
}

local FileFormat = {
    flexible = 2,
    {
        static = {
            symbols = { unix = '', dos = '', mac = '' },
        },
        provider = function(self)
            return (self.symbols[vim.bo.fileformat] or vim.bo.fileformat) .. ' '
        end,
        hl = { fg = 'muted' },
    },
    { provider = '' },
}

local DefaultStatusline = {
    ModeBlock,
    Space,
    GitBlock,
    Space,
    DiffBlock,
    Align,
    Hanko,
    Align,
    MacroBlock,
    Space,
    SearchCount,
    Space,
    SelectionCount,
    Space,
    LSPBlock,
    Space,
    DiagnosticsBlock,
    Space,
    LazyUpdates,
    FileType,
    HarpoonBlock,
    Space,
    FileEncoding,
    FileFormat,
    MetaBlock,
}

local SpecialName = {
    provider = function()
        local ft = vim.bo.filetype
        if ft == '' then
            return ' ' .. string.upper(vim.bo.buftype) .. ' '
        end
        return ' ' .. string.upper(ft) .. ' '
    end,
    hl = { fg = 'ink', bold = true },
}

local SpecialStatusline = {
    condition = function()
        return conditions.buffer_matches({
            buftype = { 'nofile', 'prompt', 'quickfix' },
            filetype = { 'lazy', 'mason', 'alpha', 'TelescopePrompt', 'qf' },
        })
    end,
    utils.surround({ '', '' }, function(self)
        return self:mode_color()
    end, SpecialName),
    Align,
    MetaBlock,
}

local HelpStatusline = {
    condition = function()
        return conditions.buffer_matches({
            buftype = { 'help' },
            filetype = { 'help' },
        })
    end,
    utils.surround({ '', '' }, 'carp', {
        provider = ' 󰋖 HELP ',
        hl = { fg = 'ink', bold = true },
    }),
    Space,
    {
        provider = function()
            local name = vim.api.nvim_buf_get_name(0)
            return vim.fn.fnamemodify(name, ':t')
        end,
        hl = { fg = 'sakura', bold = true },
    },
    Align,
    MetaBlock,
}

local TerminalStatusline = {
    condition = function()
        return conditions.buffer_matches({
            buftype = { 'terminal' },
            filetype = { 'yazi', 'toggleterm' },
        })
    end,
    utils.surround({ '', '' }, 'wave', {
        provider = ' 端 TERMINAL ',
        hl = { fg = 'ink', bold = true },
    }),
    Space,
    {
        provider = function()
            return vim.fn.fnamemodify(vim.fn.getcwd(0), ':~')
        end,
        hl = { fg = 'wave', bold = true },
    },
    Align,
    MetaBlock,
}

local StatusLines = {
    hl = { bg = 'none' },
    static = {
        mode_colors_map = {
            n = 'crystal',
            i = 'spring',
            v = 'oni',
            V = 'oni',
            ['\22'] = 'oni',
            c = 'carp',
            s = 'sakura',
            S = 'sakura',
            ['\19'] = 'sakura',
            R = 'peach',
            r = 'peach',
            ['!'] = 'samurai',
            t = 'wave',
        },
        mode_color = function(self)
            local mode = conditions.is_active() and vim.fn.mode() or 'n'
            return self.mode_colors_map[mode]
        end,
    },
    fallthrough = false,
    HelpStatusline,
    TerminalStatusline,
    SpecialStatusline,
    DefaultStatusline,
}

require('heirline').setup({
    statusline = StatusLines,
    opts = {
        colors = setup_colors,
    },
})

vim.api.nvim_create_autocmd('ColorScheme', {
    group = augroup,
    callback = function()
        utils.on_colorscheme(setup_colors)
    end,
})
