local add, later = MiniDeps.add, MiniDeps.later

later(function()
    add('folke/which-key.nvim')
    require('which-key').setup()
end)

-- Tmux navigation: skip inside devcontainers
if not vim.env.REMOTE_CONTAINERS then
    later(function()
        add('alexghergh/nvim-tmux-navigation')
        require('nvim-tmux-navigation').setup({
            disable_when_zoomed = true,
            keybindings = {
                left        = '<C-h>',
                down        = '<C-j>',
                up          = '<C-k>',
                right       = '<C-l>',
                last_active = '<C-\\>',
                next        = '<C-Space>',
            },
        })
    end)
end
