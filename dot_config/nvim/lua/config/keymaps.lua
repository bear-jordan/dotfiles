local wk = require('which-key')

wk.add({
    -- Groups
    { '<leader>c',  group = 'code actions' },
    { '<leader>r',  group = 'lsp' },
    { '<leader>d',  group = 'diagnostics' },
    { '<leader>f',  group = 'find' },
    { '<leader>h',  group = 'harpoon' },
    { '<leader>x',  group = 'trouble' },
    { '<leader>m',  group = 'format/lint' },

    -- LSP
    { 'gD',              vim.lsp.buf.declaration,    desc = 'Go to declaration' },
    { '<leader>ca',      vim.lsp.buf.code_action,    desc = 'Code actions', mode = { 'n', 'v' } },
    { '<leader>rn',      vim.lsp.buf.rename,         desc = 'Smart rename' },
    { '<leader>rs',      ':LspRestart<CR>',          desc = 'Restart LSP' },
    { '<leader>D',       vim.diagnostic.open_float,  desc = 'Show line diagnostics' },
    { 'K',               vim.lsp.buf.hover,          desc = 'Show documentation' },
    { '[d',              vim.diagnostic.goto_prev,   desc = 'Prev diagnostic' },
    { ']d',              vim.diagnostic.goto_next,   desc = 'Next diagnostic' },
})
