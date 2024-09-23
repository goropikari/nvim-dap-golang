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
