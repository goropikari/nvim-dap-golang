-- [[ Configure Telescope ]]
local wk = require('which-key')

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print('Not a git repository. Searching on current working directory')
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep({
      search_dirs = { git_root },
    })
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- See `:help telescope.builtin`
wk.add({
  {
    '<leader>?',
    require('telescope.builtin').oldfiles,
    desc = '[?] Find recently opened files',
  },
  {
    '<leader><space>',
    require('telescope.builtin').buffers,
    desc = '[ ] Find existing buffers',
  },
  {
    '<leader>/',
    function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end,
    desc = '[/] Fuzzily search in current buffer',
  },
  {
    '<leader>p',
    function()
      require('telescope.builtin').find_files({ hidden = true, file_ignore_patterns = { '.git/' } })
    end,
    desc = 'search file',
  },
})

local function telescope_live_grep_open_files()
  require('telescope.builtin').live_grep({
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  })
end
wk.add({
  { '<leader>s/', telescope_live_grep_open_files, desc = 'Search [/] in Open Files' },
  { '<leader>sb', require('telescope.builtin').current_buffer_fuzzy_find, desc = 'Search current Buffer' },
  { '<leader>ss', require('telescope.builtin').builtin, desc = 'Search Select Telescope' },
  { '<leader>gf', require('telescope.builtin').git_files, desc = 'Search Git Files' },
  { '<leader>gs', require('telescope.builtin').git_status, desc = 'Search Git Status' },
  { '<leader>sf', require('telescope.builtin').find_files, desc = 'Search Files' },
  { '<leader>sh', require('telescope.builtin').help_tags, desc = 'Search Help' },
  { '<leader>sw', require('telescope.builtin').grep_string, desc = 'Search current [W]ord' },
  { '<leader>sg', require('telescope.builtin').live_grep, desc = 'Search by Grep' },
  { '<leader>sG', ':LiveGrepGitRoot<cr>', desc = 'Search by Grep on Git Root' },
  { '<leader>sd', require('telescope.builtin').diagnostics, desc = 'Search Diagnostics' },
})
