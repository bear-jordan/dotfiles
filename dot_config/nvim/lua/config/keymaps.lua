-- Non-plugin keymaps only
-- Plugin keymaps are registered in their respective plugin files
-- which-key groups are registered in plugins/workflow.lua

vim.keymap.set('n', '<Esc>', ':noh<CR><Esc>', { noremap = true, silent = true })
