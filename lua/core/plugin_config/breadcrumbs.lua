-- triggers CursorHold event faster
vim.opt.updatetime = 300

require("barbecue").setup({
    create_autocmd = false, -- prevent barbecue from updating itself automatically
})

vim.api.nvim_create_autocmd({
    "BufWinEnter",
    "CursorHold",
    "InsertLeave",

    -- include this if you have set `show_modified` to `true`
    "BufModifiedSet",
}, {
    group = vim.api.nvim_create_augroup("barbecue.updater", {}),
    callback = function()
        require("barbecue.ui").update()
    end,
})

