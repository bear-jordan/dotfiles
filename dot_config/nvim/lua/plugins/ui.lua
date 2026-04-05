local add, now = MiniDeps.add, MiniDeps.now

now(function()
    add('folke/tokyonight.nvim')
    vim.cmd('colorscheme tokyonight-night')
end)

now(function()
    add('echasnovski/mini.icons')
    require('mini.icons').setup()
end)

now(function()
    add('echasnovski/mini.statusline')
    require('mini.statusline').setup()
end)
