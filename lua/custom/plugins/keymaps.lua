-- [[ Basic Keymaps ]]

-- document existing key chains
require('which-key').register {
  ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
  ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
  ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
  ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
  ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
  ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
  -- ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
  ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
}
-- register which-key VISUAL mode
-- required for visual <leader>hs (hunk stage) to work
require('which-key').register({
  ['<leader>'] = { name = 'VISUAL <leader>' },
  ['<leader>h'] = { 'Git [H]unk' },
}, { mode = 'v' })

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
-- vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
-- vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })


-- Comment:  Ctrl-/
vim.keymap.set('n', '<c-_>', require('Comment.api').toggle.linewise.current, { desc = 'Comment toggle linewise' })
vim.keymap.set('x', '<c-_>', '<ESC><CMD>lua require("Comment.api").locked("toggle.linewise")(vim.fn.visualmode())<CR>',
  { desc = 'Comment toggle linewise' })

-- -- flash.nvim
-- require('which-key').register({
--     -- flash search
--     l = {
--         name = "flash",
--         s = { function() require("flash").jump() end, "Flash Jump" },
--         t = { function() require("flash").treesitter() end, "Flash Treesitter" },
--         r = { function() require("flash").treesitter_search() end, "Flash Treesitter Search" },
--     },
-- }, { prefix = "<leader>" })

-- 開いている window を番号で選択する
vim.keymap.set('n', '<leader>cc', require('chowcho').run, { desc = "choose window" })

-- terminal mode を escape で抜ける
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])
vim.keymap.set('n', '<c-t>', function() vim.cmd('ToggleTerm') end)
vim.keymap.set('t', '<c-t>', function() vim.cmd('ToggleTerm') end)

-- [[ neotest ]]
local function common_neotest()
  local nt = require('neotest')
  nt.summary.open()
  os.execute('sleep 0.1')
end
require('which-key').register({
  -- flash search
  t = {
    name = "[T]est",
    s = { function()
      local nt = require('neotest')
      common_neotest()
      nt.run.run()
    end, "[T]est [S]ingle" },
    a = { function()
      local nt = require('neotest')
      common_neotest()
      nt.run.run(vim.fn.expand('%'))
    end, "[T]est [A]ll" },
    d = { function()
      local nt = require('neotest')
      common_neotest()
      nt.run.run({ strategy = "dap" })
    end, "[T]est [D]ebug" },
    o = { function()
      local nt = require('neotest')
      common_neotest()
      nt.output.open()
    end, "[T]est [O]utput" },
  },
}, { prefix = "<leader>" })

-- [[ nvim-dap ]]
-- Basic debugging keymaps, feel free to change to your liking!
local dap = require('dap')
local dapui = require('dapui')
local dapgo = require 'dap-go'
vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>B', function()
  dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, { desc = 'Debug: Set Breakpoint' })
vim.keymap.set('n', '<leader>dt', dapgo.debug_test, { desc = '[D]ebug [T]est' })
vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

-- ssh, docker 内で copy したものをホストの clipboard に入れる
vim.keymap.set('n', '<leader>c', require('osc52').copy_operator, { expr = true })
vim.keymap.set('n', '<leader>cc', '<leader>c_', { remap = true })
vim.keymap.set('v', '<leader>c', require('osc52').copy_visual)
