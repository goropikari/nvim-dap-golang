-- [[noice.vim]]
require('noice').setup {
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
}

-- require('notify').setup({
--   background_colour = '#000000',
-- })

require('gitsigns').setup {
  -- See `:help gitsigns.txt`
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  -- on_attach = function(bufnr)
  --   local gs = package.loaded.gitsigns
  --
  --   local function map(mode, l, r, opts)
  --     opts = opts or {}
  --     opts.buffer = bufnr
  --     vim.keymap.set(mode, l, r, opts)
  --   end
  --
  --   -- Navigation
  --   -- map({ 'n', 'v' }, ']c', function()
  --   --   if vim.wo.diff then
  --   --     return ']c'
  --   --   end
  --   --   vim.schedule(function()
  --   --     gs.next_hunk()
  --   --   end)
  --   --   return '<Ignore>'
  --   -- end, { expr = true, desc = 'Jump to next hunk' })
  --   --
  --   -- map({ 'n', 'v' }, '[c', function()
  --   --   if vim.wo.diff then
  --   --     return '[c'
  --   --   end
  --   --   vim.schedule(function()
  --   --     gs.prev_hunk()
  --   --   end)
  --   --   return '<Ignore>'
  --   -- end, { expr = true, desc = 'Jump to previous hunk' })
  --
  --   -- Actions
  --   -- visual mode
  --   -- map('v', '<leader>hs', function()
  --   --   gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
  --   -- end, { desc = 'stage git hunk' })
  --   -- map('v', '<leader>hr', function()
  --   --   gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
  --   -- end, { desc = 'reset git hunk' })
  --   -- normal mode
  --   -- map('n', '<leader>hs', gs.stage_hunk, { desc = 'git stage hunk' })
  --   -- map('n', '<leader>hr', gs.reset_hunk, { desc = 'git reset hunk' })
  --   -- map('n', '<leader>hS', gs.stage_buffer, { desc = 'git Stage buffer' })
  --   -- map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
  --   -- map('n', '<leader>hR', gs.reset_buffer, { desc = 'git Reset buffer' })
  --   -- map('n', '<leader>hp', gs.preview_hunk, { desc = 'preview git hunk' })
  --   -- map('n', '<leader>hb', function()
  --   --   gs.blame_line { full = false }
  --   -- end, { desc = 'git blame line' })
  --   -- map('n', '<leader>hd', gs.diffthis, { desc = 'git diff against index' })
  --   -- map('n', '<leader>hD', function()
  --   --   gs.diffthis '~'
  --   -- end, { desc = 'git diff against last commit' })
  --
  --   -- Toggles
  --   -- map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'toggle git blame line' })
  --   -- map('n', '<leader>td', gs.toggle_deleted, { desc = 'toggle git show deleted' })
  --
  --   -- Text object
  --   -- map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
  -- end,
}

-- require('neo-tree').setup({
--   sources = { "filesystem", "buffers", "git_status", "document_symbols" },
--   open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
--   hijack_netrw_behavior = "disabled",
--   filesystem = {
--     bind_to_cwd = false,
--     follow_current_file = { enabled = true },
--     use_libuv_file_watcher = true,
--     filtered_items = {
--       hide_dotfiles = false,
--     },
--   },
--   window = {
--     mappings = {
--       ["<space>"] = "none",
--       ["Y"] = function(state)
--         local node = state.tree:get_node()
--         local path = node:get_id()
--         vim.fn.setreg("+", path, "c")
--       end,
--     },
--   },
--   default_component_configs = {
--     indent = {
--       with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
--       expander_collapsed = "",
--       expander_expanded = "",
--       expander_highlight = "NeoTreeExpander",
--     },
--   },
-- })

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- ['<C-p>'] = cmp.mapping.select_prev_item(),
    -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
    -- ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    -- ['<S-Tab>'] = cmp.mapping(function(fallback)
    --   if cmp.visible() then
    --     cmp.select_prev_item()
    --   elseif luasnip.locally_jumpable(-1) then
    --     luasnip.jump(-1)
    --   else
    --     fallback()
    --   end
    -- end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  },
}

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
