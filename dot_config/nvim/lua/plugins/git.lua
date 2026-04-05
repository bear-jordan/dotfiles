local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add('lewis6991/gitsigns.nvim')
    require('gitsigns').setup({
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns
            local map = function(mode, key, cmd, desc)
                vim.keymap.set(mode, key, cmd, { buffer = bufnr, desc = desc })
            end
            map('n', ']h',          gs.next_hunk,                               'Next hunk')
            map('n', '[h',          gs.prev_hunk,                               'Prev hunk')
            map('n', '<leader>gs',  gs.stage_hunk,                              'Stage hunk')
            map('n', '<leader>gr',  gs.reset_hunk,                              'Reset hunk')
            map('n', '<leader>gp',  gs.preview_hunk,                            'Preview hunk')
            map('n', '<leader>gb',  function() gs.blame_line({ full = true }) end, 'Blame line')
        end,
    })
end)

later(function()
    add('kdheepak/lazygit.nvim')
    vim.keymap.set('n', '<leader>gg', '<cmd>LazyGit<CR>', { desc = 'LazyGit' })
end)
