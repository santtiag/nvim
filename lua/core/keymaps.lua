vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.backspace = '2'
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true

-- use spaces for tabs and whatnot
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.o.softtabstop = 4

-- new options
-- vim.o.autoindent = true  -- Activa la indentación automática
-- vim.o.smartindent = true  -- Activar indentación inteligente
-- vim.o.smarttab = true  -- Activa la indentación inteligente para el tabulador
-- vim.o.expandtab = true  -- Convierte las tabulaciones en espacios
-- vim.o.visualbell = true  -- Desactiva los sonidos y usa una alerta visual

vim.opt.showbreak = "↪ "
vim.opt.clipboard = 'unnamedplus'
-- vim.cmd('set number')
-- vim.cmd('set relativenumber')
-- vim.cmd('set cmdheight=0')
vim.opt.relativenumber = true
vim.opt.number = true

-- Change the highlight LinerNr
-- vim.cmd([[highlight LineNr guifg='#F9E2AF']])

-- vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')

-- copy
vim.api.nvim_set_keymap('v', '<C-c>', '"+y', { noremap = true, silent = true })
-- paste
vim.api.nvim_set_keymap('v', '<C-v>', '"+p', { noremap = true, silent = true })

-- Exit
vim.api.nvim_set_keymap('n', '<C-q>', ':q<CR>', { noremap = true, silent = true })

-- Save
vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })

-- Change to windows
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true, desc = 'Go to left window' })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true, desc = 'Go to lower window' })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true, desc = 'Go to upper window' })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true, desc = 'Go to right window' })

-- Resize window using <ctrl> arrow keys

vim.api.nvim_set_keymap('n', '<C-Up>', '<cmd>resize +2<cr>', { noremap = true, silent = true, desc = 'Increase window height' })
vim.api.nvim_set_keymap('n', '<C-Down>', '<cmd>resize -2<cr>', { noremap = true, silent = true, desc = 'Decrease window height' })
vim.api.nvim_set_keymap('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { noremap = true, silent = true, desc = 'Decrease window width' })
vim.api.nvim_set_keymap('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { noremap = true, silent = true, desc = 'Increase window width' })


