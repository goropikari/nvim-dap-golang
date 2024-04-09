-- [[ Basic Keymaps ]]

local wk = require('which-key')

-- document existing key chains
wk.register {
  ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
  -- ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
  -- ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
  ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
  -- ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
  ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
  -- ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
  -- ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
}
-- register which-key VISUAL mode
-- required for visual <leader>hs (hunk stage) to work
wk.register({
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
wk.register({
  e = { vim.diagnostic.open_float, 'Open floating diagnostic message' },
  q = { vim.diagnostic.setloclist, 'Open diagnostics list' },
}, { mode = 'n', prefix = '<leader>' })
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Comment:  Ctrl-/
vim.keymap.set('n', '<c-_>', require('Comment.api').toggle.linewise.current, { desc = 'Comment toggle linewise' })
vim.keymap.set('x', '<c-_>', '<ESC><CMD>lua require("Comment.api").locked("toggle.linewise")(vim.fn.visualmode())<CR>',
  { desc = 'Comment toggle linewise' })

-- 開いている window を番号で選択する
wk.register({
  ["<leader>C"] = {
    name = '[C]hoose',
    C = {
      require('chowcho').run,
      "choose window",
    }
  }
}, { mode = 'n' })

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
wk.register({
  -- flash search
  t = {
    name = "[T]est",
    s = {
      function()
        local nt = require('neotest')
        common_neotest()
        nt.run.run()
      end,
      "[T]est [S]ingle",
    },
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
wk.register({
  d = {
    name = 'Debug',
    b = { dap.toggle_breakpoint, 'Debug: Toggle Breakpoint' },
    t = { dapgo.debug_test, '[D]ebug Go [T]est' }
  },
}, { prefix = '<leader>', mode = 'n' })

-- [[ osc52 ]]
-- ssh, docker 内で copy したものをホストの clipboard に入れる
wk.register({
  ['<leader>y'] = { name = '[Y]ank', require('osc52').copy_operator, "osc52: copy", expr = true },
  ["<leader>yy"] = { '<leader>y_', 'osc52: copy line', noremap = false },
}, { mode = 'n' })
wk.register({
  ["<leader>y"] = { require('osc52').copy_visual, 'osc52: copy clipboard' },
}, { mode = 'v' })

-- [[ Noice ]]
wk.register({
  ['<leader>nl'] = { function() require("noice").cmd("last") end, "[N]oice [L]ast" }
})

-- [[ gitsigns ]]
require('gitsigns')
local gs = package.loaded.gitsigns
wk.register({
  b = {
    function()
      gs.blame_line { full = false }
    end,
    'git blame line'
  },
  d = { gs.diffthis, 'git diff against index' },
  D = { function() gs.diffthis '~' end, 'git diff against last commit' },
  p = { gs.preview_hunk, 'preview git hunk' },
  r = { gs.reset_hunk, 'git reset hunk' },
  R = { gs.reset_buffer, 'git Reset buffer' },
  s = { gs.stage_hunk, 'git stage hunk' },
  S = { gs.stage_buffer, 'git Stage buffer' },
  u = { gs.undo_stage_hunk, 'undo stage hunk' },
}, { mode = 'n', prefix = '<leader>h', desc = 'Git [H]ank' })
wk.register({
  s = {
    function() gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end,
    'stage git hunk',
  },
  -- r = {
  --   function() gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end,
  --   'reset git hunk',
  -- },
}, { mode = 'v', prefix = '<leader>h' })
local jump_hunk = {
  ["]c"] = {
    function()
      if vim.wo.diff then
        return ']c'
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return '<Ignore>'
    end,
    'Jump to next hunk'
  },
  ["[c"] = {
    function()
      if vim.wo.diff then
        return '[c'
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return '<Ignore>'
    end,
    'Jump to previous hunk'
  },
}
wk.register(jump_hunk, { mode = 'n', expr = true })
-- wk.register(jump_hunk, { mode = 'v', expr = true })
-- wk.register({
--   ['ih'] = {
--     ':<C-U>Gitsigns select_hunk<CR>',
--     'select git hunk'
--   }
-- }, { mode = { 'o', 'x' } })
