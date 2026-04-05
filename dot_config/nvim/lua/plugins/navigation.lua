local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add('stevearc/oil.nvim')
    require('oil').setup()
    vim.keymap.set('n', '-', '<cmd>Oil<CR>', { desc = 'Open parent directory' })
end)

later(function()
    add({
        source = 'nvim-telescope/telescope.nvim',
        depends = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-ui-select.nvim',
        },
    })
    local telescope = require('telescope')
    telescope.setup({
        extensions = {
            ['ui-select'] = { require('telescope.themes').get_dropdown() },
        },
    })
    telescope.load_extension('ui-select')

    local map = vim.keymap.set
    map('n', '<leader>ff', '<cmd>Telescope find_files<cr>',            { desc = 'Find files' })
    map('n', '<leader>fa', '<cmd>Telescope find_files hidden=true<cr>', { desc = 'Find all files' })
    map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>',             { desc = 'Live grep' })
    map('n', '<leader>fr', '<cmd>Telescope oldfiles<cr>',              { desc = 'Recent files' })
    map('n', '<leader>fs', '<cmd>Telescope grep_string<cr>',           { desc = 'Grep string' })
end)

later(function()
    add({
        source = 'ThePrimeagen/harpoon',
        checkout = 'harpoon2',
        depends = { 'nvim-lua/plenary.nvim' },
    })
    local harpoon = require('harpoon')
    harpoon.setup()

    local map = vim.keymap.set
    map('n', '<leader>hx', function() harpoon:list():add() end,                          { desc = 'Mark file' })
    map('n', '<leader>hm', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,  { desc = 'Harpoon menu' })
    map('n', '<leader>h1', function() harpoon:list():select(1) end,                      { desc = 'Harpoon file 1' })
    map('n', '<leader>h2', function() harpoon:list():select(2) end,                      { desc = 'Harpoon file 2' })
    map('n', '<leader>h3', function() harpoon:list():select(3) end,                      { desc = 'Harpoon file 3' })
    map('n', '<leader>h4', function() harpoon:list():select(4) end,                      { desc = 'Harpoon file 4' })
    map('n', '<leader>h[', function() harpoon:list():prev() end,                         { desc = 'Prev harpoon' })
    map('n', '<leader>h]', function() harpoon:list():next() end,                         { desc = 'Next harpoon' })
end)
