local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add('echasnovski/mini.pairs')
    require('mini.pairs').setup()
end)

later(function()
    add('numToStr/Comment.nvim')
    require('Comment').setup()
end)

later(function()
    add({
        source = 'nvim-treesitter/nvim-treesitter',
        hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
    })
    require('nvim-treesitter.configs').setup({
        ensure_installed = {
            'bash', 'dockerfile', 'go', 'hcl', 'json', 'lua',
            'markdown', 'markdown_inline', 'python', 'sql', 'yaml',
        },
        highlight = { enable = true },
        indent = { enable = true },
    })
end)
