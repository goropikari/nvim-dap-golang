-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
M = {}

local dap = require('dap')

dap.configurations.go = dap.configurations.go or {}

vim.list_extend(dap.configurations.go, {
  {
    type = 'golang',
    name = 'Debug (UDS)',
    request = 'launch',
    mode = 'debug',
    program = '${file}',
    args = {},
  },
  {
    type = 'golang',
    name = 'Debug executable (UDS)',
    request = 'launch',
    mode = 'exec',
    program = '${fileBasenameNoExtension}',
    args = {},
  },
  {
    type = 'golang',
    name = 'Debug attach process (UDS)',
    request = 'attach',
    mode = 'local',
    args = {},
    -- processId = '${command:pickProcess}',
    -- pick_process を使う方法だと adapter で tonumber を使わなくても良い
    processId = function()
      return require('dap.utils').pick_process()
    end,
  },
  {
    type = 'golang',
    name = 'Replay (UDS)',
    request = 'launch',
    mode = 'replay',
    traceDirPath = '/home/arch/.local/share/rr/main-10',
  },
  {
    type = 'golang',
    name = 'Core (UDS)',
    request = 'launch',
    mode = 'core',
    program = '${fileBasenameNoExtension}',
    coreFilePath = '/home/arch/workspace/lang_samples/go/core.755370',
  },
})

-- dap.adapters.golang = function(callback, config, parent)
--   local uds = os.tmpname() .. '.sock'
--   local args = { 'dap', '-l', 'unix:' .. uds }
--   vim.list_extend(args, config.args or {})
--   callback({
--     type = 'pipe',
--     pipe = uds,
--     executable = {
--       command = 'dlv',
--       args = args,
--     },
--     enrich_config = function(cfg, on_config)
--       local final_config = vim.deepcopy(cfg)
--       if cfg.processId then
--         final_config.processId = tonumber(cfg.processId)
--       end
--       on_config(final_config)
--     end,
--   })
-- end

dap.adapters.golang = function(cb, cfg, parent)
  local uds = os.tmpname() .. '.sock'
  cb({
    type = 'pipe',
    pipe = uds,
    executable = {
      command = 'dlv',
      args = { 'dap', '-l', 'unix:' .. uds },
    },
  })
end

function M.setup(opts) end

return M
