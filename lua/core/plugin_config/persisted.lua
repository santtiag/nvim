-- sin 'terminal' ni 'blank': no restaurar yazi, lazygit ni ventanas vacías
vim.o.sessionoptions = 'buffers,curdir,folds,tabpages,winsize'

local function is_codediff(buf)
    return vim.bo[buf].filetype:match('^codediff') or vim.api.nvim_buf_get_name(buf):match('^codediff://')
end

require('persisted').setup({
    autoload = false, -- el dashboard sigue apareciendo; se restaura con el botón 's'
    should_save = function()
        return vim.bo.filetype ~= 'alpha'
    end,
    -- las pestañas de codediff apuntan a buffers virtuales que no se pueden restaurar
    before_save = function()
        for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
                if is_codediff(vim.api.nvim_win_get_buf(win)) then
                    pcall(vim.cmd.tabclose, vim.api.nvim_tabpage_get_number(tab))
                    break
                end
            end
        end
    end,
})
