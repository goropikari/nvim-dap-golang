# nvim-dap-golang

Yet another [nvim-dap][3] extension for Golang.
Conneting delve via Unix Domain Socket.

## Installation

[lazy.nvim][4]

```lua
{
  'goropikari/nvim-dap-golang'
  opts = {
    -- default configuration
    configurations = {},
    delve_path = 'dlv',
    delve_args = {},
    remote_host = os.getenv('DAP_DELVE_HOST') or '127.0.0.1',
    remote_port = os.getenv('DAP_DELVE_PORT') and tonumber(os.getenv('DAP_DELVE_PORT')) or 12345,
  },
  ft = { 'go' },
},
```

## Usage

Debug test integrating with [neotest-golang][1].

```lua
{
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    {
      'fredrikaverpil/neotest-golang',
      enabled = vim.fn.executable('go') == 1,
    },
  },
  keys = {
    {
      '<leader>td',
      function()
        ---@diagnostic disable-next-line
        require('neotest').run.run({ strategy = 'dap' })
      end,
      desc = 'Test Debug',
    },
  },
  config = function()
    local neotest_ns = vim.api.nvim_create_namespace('neotest')
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
          return message
        end,
      },
    }, neotest_ns)

    local langs = {
      {
        executable = 'go',
        plugin_name = 'neotest-golang',
        opts = {
          args = { '--shuffle=on' },
          experimental = {
            test_table = true,
          },
        },
      },
    }
    local adapters = {}
    for _, v in pairs(langs) do
      if vim.fn.executable(v.executable) == 1 then
        table.insert(adapters, require(v.plugin_name)(v.opts))
      end
    end

    ---@diagnostic disable-next-line
    require('neotest').setup({
      diagnostic = {
        enabled = true,
        severity = 4,
      },
      status = {
        enabled = true,
        signs = true,
        virtual_text = true,
      },
      output = {
        enabled = true,
        open_on_run = true,
      },
      adapters = adapters,
      log_level = 3,
    })
  end,
}
```

## Alternative

- [leoluz/nvim-dap-go][2]

[1]: https://github.com/fredrikaverpil/neotest-golang
[2]: https://github.com/leoluz/nvim-dap-go
[3]: https://github.com/mfussenegger/nvim-dap
[4]: https://github.com/folke/lazy.nvim
