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

-- [[ Configuration DAP ]]
local dap = require 'dap'
local dapui = require 'dapui'
require('nvim-dap-virtual-text').setup {}
require('telescope').load_extension 'dap'

-- Dap UI setup
-- For more information, see |:help nvim-dap-ui|
dapui.setup()

-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
-- dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

-- [[ golang ]]
dap.adapters.delve = function(callback, config)
  callback { type = 'server', host = config.host, port = config.port }
end
-- dap.adapters.delve = { -- ベタ書きする方法もある
--   type = 'server',
--   host = '127.0.0.1',
--   port = 8081
-- }

-- dap adapter
local dap_adapters = {}
local langs = {
  -- { executable, dap-adapter }
  { lang = 'go', adapter = 'delve' },
  { lang = 'python', adapter = 'debugpy' },
  { lang = 'ruby' },
}
for _, config in ipairs(langs) do
  if vim.fn.executable(config.lang) == 1 and config.adapter then
    table.insert(dap_adapters, config.adapter)
  end
end

-- install dap adapter
require('mason-nvim-dap').setup {
  automatic_installation = true,
  ensure_installed = dap_adapters,
}
