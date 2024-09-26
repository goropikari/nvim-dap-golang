-- [[ Basic Keymaps ]]

local wk = require('which-key')

-- document existing key chains
wk.add({
  { '<leader>s', group = 'Search or surround' },
  { '<leader>s_', hidden = true },
})

wk.add({
  {
    '<leader>cd',
    function()
      vim.cmd(':tcd ' .. vim.fn.expand('%:p:h'))
    end,
    desc = 'change directory of current file',
  },
  {
    '<leader>ce',
    function()
      vim.cmd(':tabnew ~/.config/nvim/init.lua')
      vim.cmd(':tcd ~/.config/nvim')
      -- vim.cmd('Neotree show')
    end,
    desc = 'edit neovim config',
  },
})

-- Diagnostic keymaps
wk.add({
  { '<leader>e', vim.diagnostic.open_float, desc = 'Open floating diagnostic message' },
  { '<leader>q', vim.diagnostic.setloclist, desc = 'Open diagnostics list' },
})
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })

-- terminal mode を escape で抜ける
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

-- [[ nvim-dap ]]
-- Basic debugging keymaps, feel free to change to your liking!
-- wk.add({
--   { '<leader>d', group = 'Debug' },
-- })

-- [[ osc52 ]]
-- ssh, docker 内で copy したものをホストの clipboard に入れる
wk.add({
  {
    '<leader>y',
    expr = true,
    group = 'Yank',
    replace_keycodes = false,
  },
})

-- [[ Noice ]]
wk.add({
  { '<leader>n', desc = 'Noice' },
})

-- [[ barbar.nvim ]]
wk.add({
  { '<leader>b', group = 'Buffer' },
  { '<leader>bc', group = 'Buffer Clear' },
})
