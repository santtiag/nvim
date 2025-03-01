require('telescope').setup()

local builtin = require('telescope.builtin')

-- Find
vim.keymap.set('n', '<leader>ff', builtin.fd, { desc = 'Find Files (root dir)' })

vim.api.nvim_set_keymap('n', '<leader>fF', "<cmd>lua require('telescope.builtin').fd({ cwd = '$HOME' })<CR>",
    { noremap = true, silent = true, desc = 'Find Files (cwd)' })

vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live Grep (root dir)' })

vim.api.nvim_set_keymap('n', '<leader>fG', "<cmd>lua require('telescope.builtin').live_grep({ cwd = '$HOME' })<CR>",
    { noremap = true, silent = true, desc = 'Live Grep (cwd)' })

vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help Tags' })

vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Recently Opened Files' })

vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
