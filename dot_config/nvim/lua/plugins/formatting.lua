local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add('stevearc/conform.nvim')
    require('conform').setup({
        formatters_by_ft = {
            lua    = { 'stylua' },
            python = { 'ruff_format' },
            bash   = { 'shfmt' },
            sh     = { 'shfmt' },
            yaml   = { 'prettier' },
            json   = { 'prettier' },
            sql    = { 'sqlfluff' },
            tf     = { 'terraform_fmt' },
            hcl    = { 'terraform_fmt' },
        },
        formatters = {
            sqlfluff = {
                args = { 'fix', '--dialect', 'bigquery', '-' },
            },
        },
        format_after_save = {
            lsp_fallback = true,
            async = true,
            timeout_ms = 1000,
        },
    })

    vim.keymap.set({ 'n', 'v' }, '<leader>mf', function()
        require('conform').format({ async = false, timeout_ms = 1000 })
    end, { desc = 'Format file' })
end)
