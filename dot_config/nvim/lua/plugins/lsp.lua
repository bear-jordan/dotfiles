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
    add({
        source = 'williamboman/mason.nvim',
        depends = {
            'williamboman/mason-lspconfig.nvim',
        },
    })

    require('mason').setup()
    require('mason-lspconfig').setup({
        ensure_installed = {
            'bashls',
            'dockerls',
            'jsonls',
            'pyright',
            'yamlls',
        },
    })

    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- Servers managed via mise
    vim.lsp.config('lua_ls', { capabilities = capabilities })
    vim.lsp.config('terraformls', { capabilities = capabilities })
    vim.lsp.enable({ 'lua_ls', 'terraformls' })

    -- Mason-managed servers via native vim.lsp API
    require('mason-lspconfig').setup_handlers({
        function(server_name)
            vim.lsp.config(server_name, { capabilities = capabilities })
            vim.lsp.enable(server_name)
        end,
    })

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
