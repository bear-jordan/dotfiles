local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add('Saghen/blink.cmp')
    require('blink.cmp').setup({
        keymap = {
            preset = 'default',
            ['<Tab>'] = { 'select_and_accept', 'fallback' },
        },
        sources = {
            default = { 'lsp', 'path', 'buffer' },
        },
        completion = {
            documentation = { auto_show = true },
        },
        fuzzy = { implementation = 'lua' },
    })
end)

later(function()
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- LSP servers managed via mise binaries
    -- lua_ls: lua-language-server, terraformls: terraform-ls
    vim.lsp.config('lua_ls', { capabilities = capabilities })
    vim.lsp.config('terraformls', { capabilities = capabilities })
    vim.lsp.enable({ 'lua_ls', 'terraformls' })

    -- LSP keymaps on attach
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
            local buf = ev.buf
            local map = function(mode, key, cmd, desc)
                vim.keymap.set(mode, key, cmd, { buffer = buf, desc = desc })
            end
            map('n', 'gR', '<cmd>Telescope lsp_references<CR>',       'Show LSP references')
            map('n', 'gd', '<cmd>Telescope lsp_definitions<CR>',      'Go to definitions')
            map('n', 'gi', '<cmd>Telescope lsp_implementations<CR>',  'Go to implementation')
            map('n', 'gt', '<cmd>Telescope lsp_type_definitions<CR>', 'Go to type definitions')
            map('n', '<leader>d', '<cmd>Telescope diagnostics bufnr=0<CR>', 'Buffer diagnostics')
        end,
    })
end)
