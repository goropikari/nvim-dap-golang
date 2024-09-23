-- [[ Basic Keymaps ]]

local wk = require 'which-key'

-- document existing key chains
wk.add {
  { '<leader>c', group = 'Code' },
  { '<leader>c_', hidden = true },
  { '<leader>h', group = 'Git Hunk' },
  { '<leader>h_', hidden = true },
  { '<leader>s', group = 'Search' },
  { '<leader>s_', hidden = true },
}

-- required for visual <leader>hs (hunk stage) to work
wk.add {
  { '<leader>', group = 'VISUAL <leader>', mode = 'v' },
  { '<leader>h', desc = 'Git Hunk', mode = 'v' },
}

wk.add {
  {
    '<leader>cd',
    function()
      vim.cmd(':tcd ' .. vim.fn.expand '%:p:h')
    end,
    desc = 'change directory of current file',
  },
  {
    '<leader>ce',
    function()
      vim.cmd ':tabnew ~/.config/nvim/init.lua'
      vim.cmd ':tcd ~/.config/nvim'
      -- vim.cmd('Neotree show')
    end,
    desc = 'edit neovim config',
  },
}

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
-- vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
-- vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
wk.add {
  { '<leader>e', vim.diagnostic.open_float, desc = 'Open floating diagnostic message' },
  { '<leader>q', vim.diagnostic.setloclist, desc = 'Open diagnostics list' },
}
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })

-- Comment:  Ctrl-/
-- terminal によって Ctrl-/ を Ctrl-_ に認識することがある。逆もしかり
vim.keymap.set('n', '<c-_>', require('Comment.api').toggle.linewise.current, { desc = 'Comment toggle linewise' })
vim.keymap.set('n', '<c-/>', require('Comment.api').toggle.linewise.current, { desc = 'Comment toggle linewise' })
vim.keymap.set('x', '<c-_>', '<ESC><CMD>lua require("Comment.api").locked("toggle.linewise")(vim.fn.visualmode())<CR>', { desc = 'Comment toggle linewise' })
vim.keymap.set('x', '<c-/>', '<ESC><CMD>lua require("Comment.api").locked("toggle.linewise")(vim.fn.visualmode())<CR>', { desc = 'Comment toggle linewise' })

-- 開いている window を番号で選択する
wk.add {
  { '<leader>C', group = 'Choose' },
  { '<leader>CC', require('chowcho').run, desc = 'choose window' },
}

-- terminal mode を escape で抜ける
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])
vim.keymap.set('n', '<c-t>', function()
  vim.cmd 'ToggleTerm'
end)
vim.keymap.set('t', '<c-t>', function()
  vim.cmd 'ToggleTerm'
end)

-- [[ neotest ]]
local nt = require 'neotest'
wk.add {
  { '<leader>t', group = 'Test' },
  {
    '<leader>ta',
    function()
      nt.run.run(vim.fn.expand '%')
      nt.summary.open()
    end,
    desc = 'Test All',
  },
  {
    '<leader>td',
    function()
      nt.run.run { strategy = 'dap' }
    end,
    desc = 'Test Debug',
  },
  {
    '<leader>to',
    function()
      nt.output.open()
    end,
    desc = 'Test Output',
  },
  {
    '<leader>ts',
    function()
      local exrc = vim.g.exrc
      local env = (exrc and exrc.neotest and exrc.neotest.env) or {}
      nt.run.run { env = env }
      nt.summary.open()
    end,
    desc = 'Test Single',
  },
}

-- [[ nvim-dap ]]
-- Basic debugging keymaps, feel free to change to your liking!
local dap = require 'dap'
local dapgo = require 'dap-go'
wk.add {
  { '<leader>d', group = 'Debug' },
  {
    '<leader>dC',
    dap.clear_breakpoints,
    desc = 'Debug: Clear Breakpoint',
  },
  {
    '<leader>db',
    dap.toggle_breakpoint,
    desc = 'Debug: Toggle Breakpoint',
  },
  {
    '<leader>dc',
    function()
      dap.toggle_breakpoint(vim.fn.input 'debug condition: ')
    end,
    desc = 'Debug: Toggle Conditional Breakpoint',
  },
  {
    '<leader>dt',
    dapgo.debug_test,
    desc = 'Debug Go Test',
  },
  {
    '<leader>duc',
    require('dapui').close,
    desc = 'Close DAP UI',
  },
  {
    '<F5>',
    dap.continue,
    desc = 'Debug: Continue',
  },
  {
    '<F10>',
    dap.step_over,
    desc = 'Debug: Step over',
  },
}

-- [[ osc52 ]]
-- ssh, docker 内で copy したものをホストの clipboard に入れる
wk.add {
  {
    '<leader>y',
    expr = true,
    group = '[Y]ank',
    replace_keycodes = false,
  },
  {
    '<leader>ya',
    function()
      require('osc52').copy(vim.fn.expand '%:p')
    end,
    desc = 'osc52: copy file absolute path',
  },
  {
    '<leader>yf',
    function()
      require('osc52').copy(vim.fn.expand '%:t')
    end,
    desc = 'osc52: copy current file name',
  },
  {
    '<leader>yr',
    function()
      require('osc52').copy(vim.fn.expand '%')
    end,
    desc = 'osc52: copy file relative path',
  },
  {
    '<leader>yy',
    '<leader>y_',
    desc = 'osc52: copy line',
    remap = true,
  },
}
wk.add {
  { '<leader>y', require('osc52').copy_visual, desc = 'osc52: copy clipboard', mode = 'v' },
}

-- [[ Noice ]]
wk.add {
  { '<leader>n', desc = 'Noice' },
  {
    '<leader>ne',
    function()
      require('noice').cmd 'error'
    end,
    desc = 'Noice Error',
  },
  {
    '<leader>nl',
    function()
      require('noice').cmd 'last'
    end,
    desc = 'Noice [L]ast',
  },
}

-- [[ gitsigns ]]
require 'gitsigns'
local gs = package.loaded.gitsigns
wk.add {
  { '<leader>h', desc = 'Git Hank' },
  {
    '<leader>hD',
    function()
      gs.diffthis '~'
    end,
    desc = 'git diff against last commit',
  },
  {
    '<leader>hR',
    gs.reset_buffer,
    desc = 'git Reset buffer',
  },
  {
    '<leader>hS',
    gs.stage_buffer,
    desc = 'git Stage buffer',
  },
  {
    '<leader>hb',
    function()
      gs.blame_line { full = false }
    end,
    desc = 'git blame line',
  },
  {
    '<leader>hd',
    gs.diffthis,
    desc = 'git diff against index',
  },
  {
    '<leader>hp',
    gs.preview_hunk,
    desc = 'preview git hunk',
  },
  {
    '<leader>hr',
    gs.reset_hunk,
    desc = 'git reset hunk',
  },
  {
    '<leader>hs',
    gs.stage_hunk,
    desc = 'git stage hunk',
  },
  {
    '<leader>hu',
    gs.undo_stage_hunk,
    desc = 'undo stage hunk',
  },
  {
    '<leader>hs',
    function()
      gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end,
    desc = 'stage git hunk',
    mode = 'v',
  },
}

wk.add {
  {
    '[c',
    function()
      if vim.wo.diff then
        return '[c'
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return '<Ignore>'
    end,
    desc = 'Jump to previous hunk',
    expr = true,
    replace_keycodes = false,
  },
  {
    ']c',
    function()
      if vim.wo.diff then
        return ']c'
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return '<Ignore>'
    end,
    desc = 'Jump to next hunk',
    expr = true,
    replace_keycodes = false,
  },
}

-- [[ kylechui/nvim-surround ]]
wk.add {
  {
    mode = { 'n', 'v' },
    { '<leader>s', group = 'surround' },
    { '<leader>s_', hidden = true },
  },
}
wk.add {
  { '<leader>sa', '<Plug>(nvim-surround-normal)iw', desc = 'add: [char]' },
  { '<leader>sd', '<Plug>(nvim-surround-delete)', desc = 'delete: [char]' },
  { '<leader>sr', '<Plug>(nvim-surround-change)', desc = 'replace: [from][to]' },
  { '<leader>sa', '<Plug>(nvim-surround-visual)', desc = 'add: [char]', mode = 'v' },
}

-- [[ vim-easy-align ]]
wk.add {
  { '<leader>A', '<Plug>(EasyAlign)*', desc = 'align', mode = 'v' },
}

-- [[ barbar.nvim ]]
wk.add {
  { '<leader>b', group = 'Buffer' },
  { '<leader>bN', '<Cmd>BufferPrevious<CR>', desc = 'Buffer Previous' },
  { '<leader>bc', group = 'Buffer Clear' },
  { '<leader>bca', '<Cmd>BufferCloseAllButCurrent<CR><C-w><C-o><CR>', desc = 'close all buffer but current' },
  { '<leader>bcc', '<Cmd>BufferClose<CR><Cmd>q<CR>', desc = 'close buffer' },
  { '<leader>bn', '<Cmd>BufferNext<CR>', desc = 'Buffer Next' },
}
