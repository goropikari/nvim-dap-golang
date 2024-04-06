-- [[ colorscheme ]]
require('gruvbox').setup({
  italic = {
    strings = false,
    emphasis = false,
    comments = true,
    operators = false,
    folds = true,
  },
  undercurl = true,
  underline = true,
  bold = false,
  overrides = {
    LineNr = { fg = "#C0D4C0" },  -- line number の色を変える
    Comment = { fg = "#C0D4C0" }, -- line number の色を変える
  },
})
-- vim.cmd("colorscheme gruvbox")

local c = require('vscode.colors').get_colors()
require('vscode').setup({
  -- Alternatively set style in setup
  -- style = 'light'

  -- Enable transparent background
  transparent = true,

  -- Enable italic comment
  italic_comments = true,

  -- Underline `@markup.link.*` variants
  underline_links = true,

  -- Disable nvim-tree background color
  disable_nvimtree_bg = true,

  -- Override colors (see ./lua/vscode/colors.lua)
  color_overrides = {
    vscLineNumber = '#FFFFFF',
  },

  -- Override highlight groups (see ./lua/vscode/theme.lua)
  group_overrides = {
    -- this supports the same val table as vim.api.nvim_set_hl
    -- use colors from this colorscheme by requiring vscode.colors!
    -- LineNr = { fg = "#C0D4C0" },  -- line number の色を変える
    -- Comment = { fg = "#C0D4C0" }, -- line number の色を変える
  }
})
vim.cmd('colorscheme gruvbox')

-- [[noice.vim]]
require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true,         -- use a classic bottom cmdline for search
    command_palette = true,       -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false,           -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false,       -- add a border to hover docs and signature help
  },
})

-- require('notify').setup({
--   background_colour = '#000000',
-- })

require('lualine').setup({
  options = {
    icons_enabled = false,
    theme = 'auto',
    component_separators = '|',
    section_separators = '',
  },
})

require('gitsigns').setup({
  -- See `:help gitsigns.txt`
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map({ 'n', 'v' }, ']c', function()
      if vim.wo.diff then
        return ']c'
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return '<Ignore>'
    end, { expr = true, desc = 'Jump to next hunk' })

    map({ 'n', 'v' }, '[c', function()
      if vim.wo.diff then
        return '[c'
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return '<Ignore>'
    end, { expr = true, desc = 'Jump to previous hunk' })

    -- Actions
    -- visual mode
    map('v', '<leader>hs', function()
      gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'stage git hunk' })
    map('v', '<leader>hr', function()
      gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'reset git hunk' })
    -- normal mode
    map('n', '<leader>hs', gs.stage_hunk, { desc = 'git stage hunk' })
    map('n', '<leader>hr', gs.reset_hunk, { desc = 'git reset hunk' })
    map('n', '<leader>hS', gs.stage_buffer, { desc = 'git Stage buffer' })
    map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
    map('n', '<leader>hR', gs.reset_buffer, { desc = 'git Reset buffer' })
    map('n', '<leader>hp', gs.preview_hunk, { desc = 'preview git hunk' })
    map('n', '<leader>hb', function()
      gs.blame_line { full = false }
    end, { desc = 'git blame line' })
    map('n', '<leader>hd', gs.diffthis, { desc = 'git diff against index' })
    map('n', '<leader>hD', function()
      gs.diffthis '~'
    end, { desc = 'git diff against last commit' })

    -- Toggles
    -- map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'toggle git blame line' })
    -- map('n', '<leader>td', gs.toggle_deleted, { desc = 'toggle git show deleted' })

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
  end,
})

require('neo-tree').setup({
  sources = { "filesystem", "buffers", "git_status", "document_symbols" },
  open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
  filesystem = {
    bind_to_cwd = false,
    follow_current_file = { enabled = true },
    use_libuv_file_watcher = true,
    filtered_items = {
      hide_dotfiles = false,
    },
  },
  window = {
    mappings = {
      ["<space>"] = "none",
      ["Y"] = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        vim.fn.setreg("+", path, "c")
      end,
    },
  },
  default_component_configs = {
    indent = {
      with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
      expander_collapsed = "",
      expander_expanded = "",
      expander_highlight = "NeoTreeExpander",
    },
  },
})

require('chowcho').setup({
  -- Must be a single character. The length of the array is the maximum number of windows that can be moved.
  labels = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" },
  use_exclude_default = true,
  ignore_case = true,
  exclude = function(buf, win)
    -- exclude noice.nvim's cmdline_popup
    local bt = vim.api.nvim_get_option_value("buftype", { buf = buf })
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
    if bt == "nofile" and (ft == "noice" or ft == "vim") then
      return true
    end
    return false
  end,
  selector_style = 'float',
  selector = {
    float = {
      border_style = "rounded",
      icon_enabled = true,
      color = {
        label = { active = "#c8cfff", inactive = "#ababab" },
        text = { active = "#fefefe", inactive = "#d0d0d0" },
        border = { active = "#b400c8", inactive = "#fefefe" },
      },
      zindex = 1,
    },
    statusline = {
      color = {
        label = { active = "#fefefe", inactive = "#d0d0d0" },
        background = { active = "#3d7172", inactive = "#203a3a" },
      },
    },
  },
})

-- require('flash').setup()
require('lualine').setup({
  sections = {
    lualine_c = {
      {
        'filename',
        path = 3,
      }
    },
  },
})
