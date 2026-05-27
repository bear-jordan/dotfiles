local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add('stevearc/oil.nvim')
    require('oil').setup({
        default_file_explorer = true,
        keymaps = {
            ['l'] = { 'actions.select', opts = { close = true } },
            ['h'] = 'actions.parent',
            ['H'] = 'actions.toggle_hidden',
            ['q'] = 'actions.close',
        },
    })
    vim.keymap.set('n', '-', function() require('oil').open_float() end, { desc = 'Open parent directory' })
end)

later(function()
    add('alexpasmantier/tv.nvim')
    local h = require('tv').handlers
    require('tv').setup({
        channels = {
            files = {
                keybinding = '<leader>ff',
                handlers = {
                    ['<CR>']  = h.open_as_files,
                    ['<C-q>'] = h.send_to_quickfix,
                    ['<C-s>'] = h.open_in_split,
                    ['<C-v>'] = h.open_in_vsplit,
                },
            },
            ['files-hidden'] = {
                keybinding = '<leader>fa',
                handlers = {
                    ['<CR>']  = h.open_as_files,
                    ['<C-q>'] = h.send_to_quickfix,
                    ['<C-s>'] = h.open_in_split,
                    ['<C-v>'] = h.open_in_vsplit,
                },
            },
            text = {
                keybinding = '<leader>fg',
                handlers = {
                    ['<CR>']  = h.open_at_line,
                    ['<C-q>'] = h.send_to_quickfix,
                    ['<C-s>'] = h.open_in_split,
                    ['<C-v>'] = h.open_in_vsplit,
                },
            },
            ['podman-images'] = {
                keybinding = '<leader>fo',
                handlers = {
                    ['<CR>']  = function(e) vim.cmd('terminal podman run -it --rm ' .. vim.fn.shellescape(e[1]) .. ' bash') end,
                    ['<C-s>'] = function(e) vim.cmd('terminal podman run -it --rm ' .. vim.fn.shellescape(e[1]) .. ' sh') end,
                    ['<C-r>'] = function(e) vim.fn.jobstart({'podman', 'run', '-d', e[1]}) end,
                    ['<C-p>'] = function(e) vim.fn.jobstart({'podman', 'pull', e[1]}) end,
                    ['<C-d>'] = function(e) vim.fn.jobstart({'podman', 'rmi', e[1]}) end,
                },
            },
            ['podman-containers'] = {
                keybinding = '<leader>fc',
                handlers = {
                    ['<CR>']  = function(e) vim.cmd('terminal podman exec -it ' .. vim.fn.shellescape(e[1]:match('^%S+')) .. ' bash') end,
                    ['<C-s>'] = function(e) vim.cmd('terminal podman exec -it ' .. vim.fn.shellescape(e[1]:match('^%S+')) .. ' sh') end,
                    ['<C-l>'] = function(e) vim.cmd('terminal podman logs -f ' .. vim.fn.shellescape(e[1]:match('^%S+'))) end,
                    ['<C-t>'] = function(e) vim.fn.jobstart({'podman', 'stop', e[1]:match('^%S+')}) end,
                    ['<C-r>'] = function(e) vim.fn.jobstart({'podman', 'restart', e[1]:match('^%S+')}) end,
                    ['<C-d>'] = function(e) vim.fn.jobstart({'podman', 'rm', '-f', e[1]:match('^%S+')}) end,
                },
            },
            env = {
                keybinding = '<leader>fe',
                handlers = {
                    ['<CR>'] = h.insert_at_cursor,
                },
            },
        },
    })

    vim.keymap.set('n', '<leader>fs', function()
        vim.cmd('Tv text @' .. vim.fn.expand('<cword>'))
    end, { desc = 'Grep string' })
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
