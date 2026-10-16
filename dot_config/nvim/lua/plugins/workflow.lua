local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add('folke/which-key.nvim')
    local wk = require('which-key')
    wk.setup()
    wk.add({
        -- Groups
        { '<leader>b', group = 'buffer' },
        { '<leader>c', group = 'code actions' },
        { '<leader>d', group = 'diagnostics' },
        { '<leader>f', group = 'find' },
        { '<leader>g', group = 'git' },
        { '<leader>h', group = 'harpoon' },
        { '<leader>m', group = 'format/lint' },
        { '<leader>r', group = 'lsp' },
        { '<leader>w', group = 'window' },
        { '<leader>x', group = 'trouble' },

        -- LSP
        { 'gD',         vim.lsp.buf.declaration,   desc = 'Go to declaration' },
        { '<leader>ca', vim.lsp.buf.code_action,   desc = 'Code actions', mode = { 'n', 'v' } },
        { '<leader>rn', vim.lsp.buf.rename,        desc = 'Smart rename' },
        { '<leader>rs', ':LspRestart<CR>',         desc = 'Restart LSP' },
        { '<leader>D',  vim.diagnostic.open_float, desc = 'Show line diagnostics' },
        { 'K',          vim.lsp.buf.hover,         desc = 'Show documentation' },
        { '[d',         vim.diagnostic.goto_prev,  desc = 'Prev diagnostic' },
        { ']d',         vim.diagnostic.goto_next,  desc = 'Next diagnostic' },

        -- Buffer
        { '<leader>bd', '<cmd>bdelete<CR>',   desc = 'Delete buffer' },
        { '<leader>bn', '<cmd>bnext<CR>',     desc = 'Next buffer' },
        { '<leader>bp', '<cmd>bprevious<CR>', desc = 'Prev buffer' },

        -- Window
        { '<leader>wv', '<cmd>vsplit<CR>', desc = 'Vertical split' },
        { '<leader>wh', '<cmd>split<CR>',  desc = 'Horizontal split' },
        { '<leader>wx', '<cmd>close<CR>',  desc = 'Close window' },
        { '<leader>we', '<C-w>=',          desc = 'Equalize windows' },

        -- Git
        { '<leader>gg', '<cmd>LazyGit<CR>', desc = 'LazyGit' },
    })
end)

-- Split navigation; at an edge, cross into the neighbouring herdr pane (vim-herdr-navigation)
for key, dir in pairs({ h = 'left', j = 'down', k = 'up', l = 'right' }) do
    vim.keymap.set('n', '<C-' .. key .. '>', function()
        local prev = vim.api.nvim_get_current_win()
        vim.cmd('wincmd ' .. key)
        local pane = vim.env.HERDR_PANE_ID
        if vim.api.nvim_get_current_win() == prev and pane and pane ~= '' then
            -- --pane, not --current: --current is the server's focused pane, not necessarily this one
            vim.fn.system({ vim.env.HERDR_BIN_PATH or 'herdr', 'pane', 'focus', '--direction', dir, '--pane', pane })
        end
    end, { desc = 'Window ' .. dir })
end
