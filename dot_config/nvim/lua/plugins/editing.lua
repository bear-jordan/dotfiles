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
    add('kylechui/nvim-surround')
    require('nvim-surround').setup()
end)

later(function()
    add({
        source = 'nvim-treesitter/nvim-treesitter',
        checkout = 'main',
        hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
    })
    require('nvim-treesitter').install({
        'bash', 'dockerfile', 'go', 'hcl', 'json', 'lua', 'markdown',
        'markdown_inline', 'python', 'sql', 'terraform', 'yaml',
    })

    local function start(buf)
        if pcall(vim.treesitter.start, buf) then
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end
    vim.api.nvim_create_autocmd('FileType', {
        callback = function(args) start(args.buf) end,
    })
    -- This runs after startup, so buffers opened from the command line already had FileType.
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then start(buf) end
    end
end)
