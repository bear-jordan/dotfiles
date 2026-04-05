local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add('folke/trouble.nvim')
    require('trouble').setup()

    local map = vim.keymap.set
    map('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>',                              { desc = 'Diagnostics' })
    map('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',                { desc = 'Buffer diagnostics' })
    map('n', '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>',                     { desc = 'Symbols' })
    map('n', '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',      { desc = 'LSP definitions' })
    map('n', '<leader>xL', '<cmd>Trouble loclist toggle<cr>',                                 { desc = 'Location list' })
    map('n', '<leader>xQ', '<cmd>Trouble qflist toggle<cr>',                                  { desc = 'Quickfix list' })
end)

later(function()
    add('mfussenegger/nvim-lint')
    local lint = require('lint')
    lint.linters_by_ft = {
        python = { 'ruff' },
        hcl    = { 'tflint' },
        tf     = { 'tflint' },
        sql    = { 'sqlfluff' },
    }

    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = vim.api.nvim_create_augroup('lint', { clear = true }),
        callback = function() lint.try_lint() end,
    })

    vim.keymap.set('n', '<leader>ml', function() lint.try_lint() end, { desc = 'Lint file' })
end)
