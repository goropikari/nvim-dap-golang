local neotest_ns = vim.api.nvim_create_namespace("neotest")
vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      local message =
          diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
      return message
    end,
  },
}, neotest_ns)

require('neotest').setup({
  status = { virtual_text = true },
  output = { open_on_run = true },
  -- your neotest config here
  adapters = {
    require("neotest-go"),
  },
})

-- [[ Configuration DAP ]]
local dap = require 'dap'
local dapui = require 'dapui'
require("nvim-dap-virtual-text").setup({})
require('telescope').load_extension('dap')

local go_dap_adapter_name = "delve"
local ruby_dap_adapter_name = "rdbg"

-- .vscode/launch.json に書かれた remote debug の設定を nvim-dap で使える形に変更する
local function vscode_config_to_nvim_config()
  -- [[golang]]
  if dap.configurations.go ~= nil then
    for i, config in ipairs(dap.configurations.go) do
      if config.mode == "remote" or (config.debugAdapter == "dlv-dap" and config.mode == "remote") then
        config.type = go_dap_adapter_name
        dap.configurations.go[i] = config
      end
    end
  end

  -- [[ ruby ]]
  if dap.configurations.ruby ~= nil then
    for i, config in ipairs(dap.configurations.ruby) do
      if config.mode == "remote" or (config.debugAdapter == "rdbg" and config.mode == "remote") or config.debugPort ~= nil then
        config.type = ruby_dap_adapter_name
        dap.configurations.ruby[i] = config
      end
    end
  end
  if dap.configurations.rdbg ~= nil then
    for _, config in ipairs(dap.configurations.rdbg) do
      table.insert(dap.configurations.ruby, config)
    end
  end

  -- [[ c++ ]]
  if dap.configurations.cppdbg ~= nil then
    for _, config in ipairs(dap.configurations.cppdbg) do
      if config.request == 'launch' then
        config.prehook = function()
          vim.fn.system({ 'g++', '-g', '-O0', vim.fn.expand('%'), '-o', vim.fn.expand('%:r') })
        end
      end
    end
  end
end


-- Dap UI setup
-- For more information, see |:help nvim-dap-ui|
dapui.setup()

-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
-- dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

-- Install golang specific config
require('dap-go').setup({ -- Additional dap configurations can be added.
  -- dap_configurations accepts a list of tables where each entry
  -- represents a dap configuration. For more details do:
  -- :help dap-configuration
  dap_configurations = {
  },
  -- delve configurations
  delve = {
    -- the path to the executable dlv which will be used for debugging.
    -- by default, this is the "dlv" executable on your PATH.
    path = "dlv",
    -- time to wait for delve to initialize the debug session.
    -- default to 20 seconds
    initialize_timeout_sec = 20,
    -- a string that defines the port to start delve debugger.
    -- default to string "${port}" which instructs nvim-dap
    -- to start the process in a random available port
    port = "${port}",
    -- additional args to pass to dlv
    args = {},
    -- the build flags that are passed to delve.
    -- defaults to empty string, but can be used to provide flags
    -- such as "-tags=unit" to make sure the test suite is
    -- compiled during debugging, for example.
    -- passing build flags using args is ineffective, as those are
    -- ignored by delve in dap mode.
    build_flags = "",
  }
})
require('dap-ruby').setup()
require('dap.ext.vscode').load_launchjs() -- .vscode/launch.json を読み込む
vscode_config_to_nvim_config()            -- すべての config が読み込まれたあとに実行する

-- remote debug 用の adapter が作る
-- 個別の config は .vscode/launch.json に書くとプロジェクトごとの設定にできる
-- 書き方の例は後述
local function split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

dap.adapters[go_dap_adapter_name] = function(callback, config)
  callback({ type = 'server', host = config.host, port = config.port })
end
-- dap.adapters.delve = { -- ベタ書きする方法もある
--   type = 'server',
--   host = '127.0.0.1',
--   port = 8081
-- }

dap.adapters[ruby_dap_adapter_name] = function(callback, config)
  if config.port ~= nil then
    callback({ type = 'server', host = config.host, port = config.port })
  elseif config.debugPort ~= nil then
    local t = split(config.debugPort, ':')
    local host = t[1]
    local port = t[2]
    callback({ type = 'server', host = host, port = port })
  else
    callback({ type = 'server', host = 'localhost', port = 12345 })
  end
end

-- [[  cpp debug ]]
local cpptools_path = vim.fn.stdpath('data') .. '/cpptools'
if not vim.loop.fs_stat(cpptools_path) then
  -- vscode 用の dap adapter だが preLaunchTask までは扱ってくれないもよう
  vim.fn.system { 'wget', 'https://github.com/microsoft/vscode-cpptools/releases/download/v.1.19.4/cpptools-linux.vsix', '-O', vim.fn.stdpath('data') .. '/cpptools-linux.vsix' }
  vim.fn.system { 'unzip', vim.fn.stdpath('data') .. '/cpptools-linux.vsix', '-d', cpptools_path }
  vim.fn.system { 'chmod', '+x', cpptools_path .. '/extension/debugAdapters/bin/OpenDebugAD7' }
end
dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = cpptools_path .. '/extension/debugAdapters/bin/OpenDebugAD7',
}
dap.configurations.cpp = dap.configurations.cppdbg

dap.adapters.gdbdap = {
  type = "executable",
  command = "gdb",
  args = { "-i", "dap" } -- required gdb v14.x
}
if dap.configurations.cpp == nil then
  dap.configurations.cpp = {}
end
table.insert(dap.configurations.cpp, {
  -- 実行前にコンパイルする
  prehook = function()
    vim.fn.system({ 'g++', '-g', '-O0', vim.fn.expand('%'), '-o', vim.fn.expand('%:r') })
  end,
  name = "gdb dap",
  type = "gdbdap",
  request = "launch",
  program = "${workspaceFolder}/${fileBasenameNoExtension}",
  cwd = "${workspaceFolder}",
  stopAtBeginningOfMainSubprogram = false,
  -- args = { "<", "test.txt" },
})
