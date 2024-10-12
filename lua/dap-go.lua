-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
M = {}

local dap = require('dap')
dap.configurations.go = dap.configurations.go or {}

---@class TemporaryMemory
---@field args table<string>
---@field trace_dir_path string
---@field core_file_path string

---@type TemporaryMemory
local tmp_history = {
  args = {},
  trace_dir_path = '',
  core_file_path = '',
}

---@class DapConfiguration
---@field name string
---@field request 'launch'|'attach'
---@field mode 'debug'|'exec'|'local'|'replay'|'core'
---@field program? string
---@field args? table<string>
---@field host? string
---@field port? number
---@field processId? number
---@field traceDirPath? string
---@field coreFilePath? string

---@class PluginConfiguration
---@field configurations table<DapConfiguration>
---@filed delve_path string
---@filed delve_args table<string>
---@field host string
---@field port number

---@type PluginConfiguration
local default_config = {
  configurations = {},
  delve_path = 'dlv',
  delve_args = {},
  host = '127.0.0.1',
  port = 2345,
}

---@type PluginConfiguration
---@diagnostic disable-next-line
local internal_global_config = {}

---@param opts PluginConfiguration
local function setup_config(opts)
  vim.list_extend(internal_global_config, opts.configurations)
end

---@return table<string>
local function input_args()
  local prompt = 'Args:'
  if vim.fn.empty(tmp_history.args) ~= 1 then
    prompt = prompt .. ' default "' .. vim.fn.join(tmp_history.args, ' ') .. '"'
  end
  local input = vim.fn.input(prompt)
  vim.fn.trim(input)
  local ret = {}
  if input == '' then
    ret = tmp_history.args
  else
    ret = vim.fn.split(input, ' ')
    tmp_history.args = ret
  end
  return ret
end

---@return string
local function input_trace_dir_path()
  local prompt = 'trace directory path:'
  if tmp_history.trace_dir_path ~= '' then
    prompt = prompt .. ' default "' .. tmp_history.trace_dir_path .. '"'
  end
  local input = vim.fn.trim(vim.fn.input(prompt))
  local ret = tmp_history.trace_dir_path
  if input ~= '' then
    ret = input
    tmp_history.trace_dir_path = input
  end
  return ret
end

---@return string
local function input_core_file_path()
  local prompt = 'core file path:'
  if tmp_history.core_file_path ~= '' then
    prompt = prompt .. ' default "' .. tmp_history.core_file_path .. '"'
  end
  local input = vim.fn.trim(vim.fn.input(prompt))
  local ret = tmp_history.core_file_path
  if input ~= '' then
    ret = input
    tmp_history.core_file_path = input
  end
  return ret
end

vim.list_extend(dap.configurations.go, {
  {
    type = 'golang',
    name = 'Debug',
    request = 'launch',
    mode = 'debug',
    program = '${file}',
  },
  {
    type = 'golang',
    name = 'Debug with arguments',
    request = 'launch',
    mode = 'debug',
    program = '${file}',
    args = input_args,
  },
  {
    type = 'golang',
    name = 'Debug executable',
    request = 'launch',
    mode = 'exec',
    program = '${fileBasenameNoExtension}',
  },
  {
    type = 'golang',
    name = 'Debug executable with arguments',
    request = 'launch',
    mode = 'exec',
    program = '${fileBasenameNoExtension}',
    args = input_args,
  },
  {
    type = 'golang',
    name = 'Debug attach process',
    request = 'attach',
    mode = 'local',
    processId = function()
      return require('dap.utils').pick_process()
    end,
  },
  {
    type = 'golang',
    name = 'Debug remote',
    request = 'attach',
    host = '127.0.0.1',
  },
  {
    type = 'golang',
    name = 'Replay',
    request = 'launch',
    mode = 'replay',
    -- traceDirPath = '/home/arch/.local/share/rr/main-10',
    -- echo 1 | sudo tee /proc/sys/kernel/perf_event_paranoid
    -- echo 'kernel.perf_event_paranoid = 1' | sudo tee /etc/sysctl.d/10-rr.conf
    -- rr record ./main
    traceDirPath = input_trace_dir_path,
  },
  {
    type = 'golang',
    name = 'Core',
    request = 'launch',
    mode = 'core',
    program = '${fileBasenameNoExtension}',
    coreFilePath = input_core_file_path,
  },
})

---@param cb fun(adapter: dap.Adapter)
---@param cfg DapConfiguration
---@param parent dap.Session
---@diagnostic disable-next-line
dap.adapters.go = function(cb, cfg, parent)
  local uds = os.tmpname() .. '.sock'
  if cfg.mode == 'remote' then
    cb({
      type = 'server',
      host = internal_global_config.host,
      port = internal_global_config.port,
    })
  else
    cb({
      type = 'pipe',
      pipe = uds,
      executable = {
        command = 'dlv',
        args = { 'dap', '-l', 'unix:' .. uds },
      },
    })
  end
end

---@param opts PluginConfiguration
function M.setup(opts)
  opts = opts or {}
  internal_global_config = vim.tbl_deep_extend('force', default_config, opts or {})
  setup_config(internal_global_config)
end

function M.input_args()
  return input_args()
end

function M.input_trace_dir_path()
  return input_trace_dir_path()
end

function M.input_core_file_path()
  return input_core_file_path()
end

return M
