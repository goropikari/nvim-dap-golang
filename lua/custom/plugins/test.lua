local neotest_ns = vim.api.nvim_create_namespace 'neotest'
vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
      return message
    end,
  },
}, neotest_ns)

require('neotest').setup {
  status = {
    enabled = true,
    signs = true,
    virtual_text = true,
  },
  output = {
    enabled = true,
    open_on_run = true,
  },
  -- your neotest config here
  adapters = {
    require 'neotest-go' {
      args = { '--shuffle=on' },
    },
  },
  log_level = 3,
}
