-- [[ Basic Keymaps ]]

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

vim.keymap.set('n', '<leader>cc', require('chowcho').run, { desc = "choose window" })

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
    o = { function()
      local nt = require('neotest')
      common_neotest()
      nt.output.open()
    end, "[T]est [O]utput" },
  },
}, { prefix = "<leader>" })
