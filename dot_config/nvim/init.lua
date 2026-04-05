-- Bootstrap mini.deps
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.deps'
if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.deps`" | redraw')
    vim.fn.system({
        'git', 'clone', '--filter=blob:none',
        'https://github.com/echasnovski/mini.deps', mini_path,
    })
    vim.cmd('packadd mini.deps | helptags ALL')
end

require('mini.deps').setup({ path = { package = path_package } })

-- Config
require('config.options')

-- Plugins
local now, later = MiniDeps.now, MiniDeps.later

now(function() require('plugins.ui') end)
later(function() require('plugins.editing') end)
later(function() require('plugins.navigation') end)
later(function() require('plugins.lsp') end)
later(function() require('plugins.formatting') end)
later(function() require('plugins.diagnostics') end)
later(function() require('plugins.workflow') end)

-- Keymaps last (plugins must be loaded first)
later(function() require('config.keymaps') end)
